module Api
  module V1
    class BooksController < BaseController
      def index
	    @results = Book.search(params[:q])
	    
	    render :json => base(200, nil, @results.as_json)
	  end
    end
  end
end
