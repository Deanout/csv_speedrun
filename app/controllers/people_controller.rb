class PeopleController < ApplicationController
  before_action :set_person, only: %i[show edit update destroy]

  def import
    file = params[:file]

    # redirect if bad data
    return redirect_to root_path, alert: 'No file selected' unless file
    return redirect_to root_path, alert: 'Please select CSV file instead' unless file.content_type == 'text/csv'

    # import data
    csvImportService = CsvImportService.new(file)
    csvImportService.import

    # redirect with notice
    redirect_to root_path, 
    notice: "#{csvImportService.number_imported_with_last_run} people imported"
  end

  def clear
    Person.destroy_all
    redirect_to root_path, notice: 'All people deleted'
  end

  # GET /people or /people.json
  def index
    @people = Person.all
  end

  # GET /people/1 or /people/1.json
  def show; end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit; end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to person_url(@person), notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to person_url(@person), notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def person_params
    params.require(:person).permit(:name, :age)
  end
end
