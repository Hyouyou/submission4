class BooksController < ApplicationController

  def set_book
    @book = current_user.books.find(params[:id])
  end

  def show
    @book = Book.find(params[:id])
    @comment = BookComment.new
    @book_new = Book.new
    @user = @book.user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = 'You have created book successfully'
      redirect_to book_path(@book.id)
    else
      @book_new = Book.new
      @user = current_user
      @books = Book.all
      render "index"
    end
  end

  def edit
    @book = Book.find(params[:id])
    redirect_to books_path unless @book.user.id == current_user.id
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = 'You have updated book successfully'
      redirect_to book_path(@book.id)
    else
      render "edit"
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  def index
    @book =Book.new
    @user = current_user
    @users = User.all
    @books = Book.page(params[:page]).reverse_order
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

end
