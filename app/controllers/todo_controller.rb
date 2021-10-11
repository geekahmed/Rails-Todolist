class TodoController < ApplicationController
    before_action :authorized
    before_action :set_todo, only: [:show, :update, :destroy]
    
    def index
        todos = User.find(@user.id.to_s).todo_units
        render json: todos
    end

    def create
        todo = TodoUnit.new(todo_params)
        user = User.find(@user.id.to_s)
        if user.todo_units.push(todo)
            render json: todo.to_json, status: :created
        else
            render json: todo.errors, status: :unprocessable_entity
        end
    end

    def destroy
        user.todo_units.delete(@todo)

        head :no_content
    end

    def show
        render json: @todo
    end
    
    
    private

    def todo_params
        params.require(:todo).permit(:title, :desc, :image_link)
    end

    def set_todo
        @todo = User.find(@user.id.to_s).todo_units.find(params[:id])
    end
end
