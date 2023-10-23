class ChatsController < ApplicationController
    # respond only to JSON requests
    respond_to :json
    respond_to :html, only: []
    respond_to :xml, only: []

    include ChatbotHelper
    include CalltypeHelper

    def index
        content = { hello: "world" }
        render json: content, 
               status: 200
    end

    def read
        content = { hello: "world" }
        render json: content, 
               status: 200
    end

end
