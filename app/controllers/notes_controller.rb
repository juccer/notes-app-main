class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update destroy]

  def index
    @notes = Note.all

    filters = params[:filters]&.to_unsafe_h&.symbolize_keys
    if filters && filters[:search].present?
      # Buscar en título y contenido
      @notes = @notes.where("title LIKE ? OR body LIKE ?", "%#{filters[:search]}%", "%#{filters[:search]}%")
    end

    # Ordenar las notas según el parámetro de orden
    if filters && filters[:order].present?
      case filters[:order]
      when 'desc_date'
        @notes = @notes.order(created_at: :desc)  # Más reciente a más antiguo
      when 'asc_date'
        @notes = @notes.order(created_at: :asc)   # Más antiguo a más reciente
      when 'asc_alpha'
        @notes = @notes.order(:title)             # Alfabético A-Z
      when 'desc_alpha'
        @notes = @notes.order(title: :desc)       # Alfabético Z-A
      else
        @notes = @notes.order(created_at: :desc)  # Si no se pasa un parámetro válido, ordenamos por fecha por defecto
      end
    else
      # Orden por defecto: por fecha (más reciente a más antiguo)
      @notes = @notes.order(created_at: :desc)
    end
  end

  def show
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = Note.new(note_params)
  
    respond_to do |format|
      if @note.save
        format.html { redirect_to note_url(@note), notice: "Note successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to note_url(@note), notice: "Note successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end
  

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body)
  end
end
