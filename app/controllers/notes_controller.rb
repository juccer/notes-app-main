class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update destroy]

  def index
    @notes = Note.all

    # Obtener los filtros
    filters = params[:filters]&.to_unsafe_h&.symbolize_keys
    if filters
      # Filtrar por título si se proporciona
      if filters[:title].present?
        @notes = @notes.search_by_title(filters[:title])
      end

      # Ordenar según la selección
      case filters[:order]
      when 'desc_date'
        @notes = @notes.order(created_at: :desc)
      when 'asc_date'
        @notes = @notes.order(created_at: :asc)
      when 'asc_alpha'
        @notes = @notes.order(title: :asc)
      when 'desc_alpha'
        @notes = @notes.order(title: :desc)
      end
    else
      # Ordenar por defecto
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
