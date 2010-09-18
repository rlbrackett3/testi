class UsersController < ApplicationController
  before_filter :protect, :only => :index
  
  # GET /users
  # GET /users.xml
  def index
    # This will be a protected page for viewing user information
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @title = "Register"
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    if request.post? and params[:user]
      @user = User.new(params[:user])

      respond_to do |format|
        if @user.save
          session[:user_id] = @user.id # auto log in when registering using sessions
          format.html { redirect_to(@user, :notice => "User #{@user.first_name} was successfully created.") }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => "User #{user.first_name user.last_name}was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  # Login
  def login
    @title = "Log in to RailsSpace"
    if request.post? and params[:user]
      @user = User.find_by_email_and_password(params [:email], params[:password]) 
      unless @user.nil?
        session[:user_id] = @users.id
        render :notice => "User #{@user.first_name} logged in!"
        redirect_to :controller => 'users', :action => 'index'
      else
        render :notice => "Invalid email/password combination"
        redirect_to :controller => 'users/index'
      end
#      respond_to do |format|
#        if @user.save
#          session[:user_id] = @user.id # auto log in when registering using sessions
#          format.html { redirect_to(:controller => "users", 
#                                    :action => "index", 
#                                    :notice => "User #{@user.first_name} logged in!") }
#          format.xml  { render :xml => @user, :status => :logged_in, :location => 'index' }
#        else
#          @user.password = nil
#          format.html { render :notice => "Invalid email/password combination", :action => "login" }
#          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
#        end
#      end
    end
  end
  
  # Logout
  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to :action => "index", :controller => "site"
  end


private

# Protect a page from unauthoriazed access.
  def protect
    unless session[:user_id]
      flash[:notice] = "Please log in first"
      redirect_to :action => "login"
      return false
    end
  end
  
end
