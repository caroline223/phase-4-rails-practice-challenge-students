class StudentsController < ApplicationController

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    def index
        students = Student.all 
        render json: students, status: :ok
    end

    def show 
        student = find_student
        if student 
            render json: student, status: :ok
        else
            render_not_found_response
        end
    end

    def create
        student = Student.create!(student_params)
        if student.valid?
            render json: student, status: :created
        else
            render_unprocessable_entity_response
        end
    end

    def update 
        student = find_student
        if student
            student.update!(student_params)
            render json: student, status: :accepted
        else
            render_not_found_response
        end
    end

    def destroy 
        student = find_student 
        if student 
            student.destroy 
            head :no_content 
        else
            render_not_found_response
        end
    end


    private 

    def find_student 
        Student.find_by_id(params[:id])
    end

    def student_params
        params.permit(:name, :major, :age, :instructor_id)
    end

    def render_not_found_response
        render json: {error: "Student not found"}, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end



end
