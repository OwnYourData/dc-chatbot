call_id = ""

@chat = Store.where(call_id: call_id)

system_msg  = "You are an emergency services assistant who is a control operator routing emergency calls dedicated to hearing and speech impaired."
system_msg += "\nThe conversation has to be concise since the caller is possibly hearing and speech impaired and is used to short precise conversation. Only ask one question at a time. Act as the Marvin character from Hitchhikers Guide to the Galaxy."
system_msg += "\nDo not sound apologetic in conversation and do not say “I am sorry to hear it” or “Thank you for providing the information”."
system_msg += "\nDetermine the following before sending emergency: 1) how serious is the problem and type of emergency, fire, medical or police; 2) what is the address to send emergency dispatch; 3) once emergency is dispatched ask if emergency can get into the building; and 4) and if caller can hear when emergency personal arrives or are they hearing and speech impaired. In the case that emergency personnel cannot get into building inform emergency personnel what to do."
system_msg += "\nOnce all information is gathered end call stating what type of emergency will be sent, ambulance, police or firemen. If assistant says will “stay on line” do not end call but if assistant can end call text the following “I will end the chat, if something gets worse, restart the app immediately so I can help you further. The system has ended the emergency call. If you have any further questions, please call again.” If call is not an emergency end call with “The system has ended the emergency call. If you have any further questions, please call again.”."
conv = [{"time": @chat.first.created_at.strftime("%H:%M:%S"), "role": "system", "text": system_msg}.transform_keys(&:to_s)]

@chat.each do |record|
    message_array = nil
    if HAS_JSONB
        event_data = record.item.transform_keys(&:to_s)
    else
        event_data = JSON.parse(record.item).transform_keys(&:to_s)
    end
    if !event_data["call"].nil?
        if !event_data["call"]["chat"].nil?
            message_array = event_data["call"]["chat"]
        end
    else
        if !event_data["chat"].nil?
            message_array = event_data["chat"]
        end
    end
    if message_array.nil?
        if !event_data.nil? && !event_data["message"].nil?
            message_array = [event_data["message"]]
        end
    end
    message_array.each do |message|
        text = message["texts"].first rescue ""
        if text.to_s != "" && text.include?("Das ist ein TEST-Notruf von der automatischen DEC112 Systemüberwachung.")
            test_call = true
        end
        if text.to_s != "" && !text.start_with?("You wrote: ") && !text.start_with?("Phone  has initiated an emergency chat from")
            if message["origin"] == "remote"
                conv << {"time": record.created_at.strftime("%H:%M:%S"), "role": "user", "text": text}.transform_keys(&:to_s)
            end

            if message["origin"] == "local"
                if text.include?("The system has ended the emergency call.") ||
                   text.include?("Ich werde den Chat beenden.") ||
                   text.include?("Ende des Anrufs.")
                        call_ended = true
                        return_msg = "//call_ended"
                end
                if text.include?("rate the chat on a scale")
                    call_ended = true
                    return_msg = "//call_ended-1"
                end
                conv << {"time": record.created_at.strftime("%H:%M:%S"), "role": "assistant", "text": text}.transform_keys(&:to_s)
            end
            puts message["origin"] + ": " + text
        end
    end unless message_array.nil?
    nil
end