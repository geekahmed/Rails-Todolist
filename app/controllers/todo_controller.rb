class TodoController < ApplicationController
    before_action :authorized
    before_action :set_todo, only: [:show, :update, :destroy]
    
    def index
        todos = User.find(@user.id.to_s).todo_units
        render json: todos
    end

    def export
        CsvExportJob.perform_now(@user.id.to_s)
    end
    def create
        todo = TodoUnit.new(todo_params)
        user = User.find(@user.id.to_s)
        if user.todo_units.push(todo)
            ActionCable.server.broadcast("todo_units_channel", {data: todo})
            render json: todo.to_json, status: :created
        else
            render json: todo.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @user.todo_units.delete(@todo)

        head :no_content
    end

    def show
        render json: @todo, status: :ok
    end
    
    def update
        @todo.update(todo_params)
        if @user.save!
            render json: {status: "success", item: @todo}, status: :ok
        else
            render json: {error: "Error in update"}, status: :unprocessable_entity
        end
    end

    def search
        search_query = params[:q].to_s
        puts search_query
        @todos = TodoUnit.search(search_query)
        if search_query.empty?
            @todos = TodoUnit.search('*')
        end
        @us = User.search(search_query, load: false)
        render json: {status: "success", items: @todos}, status: :ok
    end

    
    private

    def todo_params
        params.require(:todo).permit(:title, :desc, :image_link)
    end

    def set_todo
        @todo = User.find(@user.id.to_s).todo_units.find(params[:id])
    end
end
