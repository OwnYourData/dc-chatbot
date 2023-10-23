# dc-chatbot

## Configuration Options

Use the following environment variables to configure the chatbot:
* `CHAT_LANG` = en | de (default: "de")
* `DEFAULT_CALLTYPE` = ambulance | fire | police (default: "ambulance")  
* `OAI_ACCESS_TOKEN` - OpenAI access token  
* `OAI_MODEL` gpt-3.5-turbo | gpt-4 (default: "gpt-3.5-turbo")
* `OAI_SYSTEM` - text file in configure/textblocks that provides configuration/context for chatbot (default: "OAI_system_default.txt")  
* `WS_ENDPOINT` - websocket endpoint
