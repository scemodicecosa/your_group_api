class DocumentationController < ApplicationController

  def show
    @doc = Documentation.find(params[:id])
  end

  def create
    @doc = Documentation.new(doc_params)
    @doc.save
    redirect_to @doc
  end

  def new
    @doc = Documentation.new
  end

  def index
    @docs = Documentation.all
  end

  def doc_params
    params.require(:documentation).permit(:title, :url, :method, :url_req, :url_opt, :params, :example, :note, :success_response, :error_response)
  end

end
