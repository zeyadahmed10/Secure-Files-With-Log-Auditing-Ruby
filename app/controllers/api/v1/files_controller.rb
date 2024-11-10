class Api::V1::FilesController < ApplicationController
    def index
        render json: {"message": "hello from files Controller"}
    end
end
