class InstructorsController < ApplicationController

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response   
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response 

    def index
        instructors = Instructor.all 
        render json: instructors, status: :ok
    end

    def show
        instructor = find_instructor
        if instructor 
            render json: instructor, status: :ok
        else
            render_not_found_response
        end
    end

    def create
        instructor = Instructor.create!(instructor_params)
        if instructor.valid?
            render json: instructor, status: :created
        else
            render_unprocessable_entity_response
        end
    end

    def update
        instructor = find_instructor
        if instructor.valid?
            instructor.update!(instructor_params)
            render json: instructor, status: :accepted 
        else
            render_unprocessable_entity_response
        end
    end

    def destroy
        instructor = find_instructor
        if instructor
            instructor.destroy
            head :no_content
        else
            render_not_found_response
        end
    end

    private

    def find_instructor
        Instructor.find_by_id(params[:id])
    end

    def instructor_params
        params.permit(:name)
    end

    def render_not_found_response
        render json: {error: "Instructor not found"}, status: :not_found 
    end

    def render_unprocessable_entity_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end


end
