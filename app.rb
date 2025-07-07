require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

enable :sessions
set :session_secret, ENV['SESSION_SECRET']

helpers do
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end
end

before do
  # Allow access to login page and login/logout process
  return if request.path_info == '/login' || request.path_info == '/logout'

  # Redirect to login if not logged in for all other pages
  redirect '/login' unless logged_in?
end

set :database_file, "config/database.yml"

require_relative 'app/models/client'
require_relative 'app/models/invoice'
require_relative 'app/models/estimate'
require_relative 'app/models/payment'
require_relative 'app/models/user'

# --- Authentication Routes ---

get '/login' do
  erb :login, layout: false # No layout for the login page
end

post '/login' do
  user = User.find_by(username: params[:username])
  if user&.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    redirect '/login'
  end
end

get '/logout' do
  session.clear
  redirect '/login'
end

# --- Password Change Routes ---

get '/password/edit' do
  erb :password_edit
end

post '/password' do
  user = current_user

  # 現在のパスワードが正しいか確認
  unless user&.authenticate(params[:current_password])
    @error = "現在のパスワードが正しくありません。"
    return erb :password_edit
  end

  # 新しいパスワードが確認用と一致するか確認
  if params[:new_password] != params[:password_confirmation]
    @error = "新しいパスワードと確認用のパスワードが一致しません。"
    return erb :password_edit
  end

  # パスワードを更新
  if user.update(password: params[:new_password])
    session[:flash] = "パスワードが正常に変更されました。"
    redirect '/' # 成功したらトップページにリダイレクト
  else
    @error = user.errors.full_messages.join(", ")
    erb :password_edit
  end
end

# --- Main Application ---


get '/' do
  erb :index, layout: :layout
end

get '/clients' do
  @clients = Client.all
  erb :clients
end

post '/clients' do
  Client.create(
    name: params[:name],
    address: params[:address],
    contact_person: params[:contact_person],
    phone_number: params[:phone_number]
  )
  redirect '/clients'
end

get '/clients/:id' do
  @client = Client.find(params[:id])
  erb :client_show
end

# 請求書作成ルート (GET /invoices/new) は /invoices/:id よりも前に配置
get '/invoices/new' do
  @invoice = Invoice.new
  if params[:estimate_id]
    @estimate = Estimate.find(params[:estimate_id])
    @invoice.client = @estimate.client
    @invoice.subject = @estimate.subject
    @invoice.amount = @estimate.amount
    @invoice.issue_date = Date.today
    @invoice.due_date = Date.today + 30 # 例: 請求日から30日後
    @invoice.direction = 'sent' # 見積書から作成する場合は「送った請求書」と仮定
    @invoice.status = 'draft' # 初期ステータスは下書き
  elsif params[:client_id]
    @invoice.client = Client.find(params[:client_id])
    @invoice.issue_date = Date.today
    @invoice.due_date = Date.today + 30
    @invoice.direction = 'sent'
    @invoice.status = 'draft'
  end
  erb :invoice_new
end

post '/invoices' do
  Invoice.create(
    client_id: params[:client_id],
    issue_date: params[:issue_date],
    due_date: params[:due_date],
    subject: params[:subject],
    amount: params[:amount],
    status: params[:status],
    direction: params[:direction]
  )
  redirect '/invoices'
end

get '/invoices/:id' do
  @invoice = Invoice.find(params[:id])
  erb :invoice_show
end

get '/invoices/:id/edit' do
  @invoice = Invoice.find(params[:id])
  erb :invoice_edit
end

post '/clients/:id/estimates' do
  @client = Client.find(params[:id])
  @client.estimates.create(
    issue_date: params[:issue_date],
    expiry_date: params[:expiry_date],
    subject: params[:subject],
    amount: params[:amount],
    status: params[:status],
    direction: params[:direction]
  )
  redirect "/clients/#{@client.id}"
end

get '/invoices' do
  @invoices = Invoice.all
  erb :invoices
end

get '/estimates' do
  @estimates = Estimate.all
  erb :estimates
end

get '/documents' do
  @invoices = Invoice.all
  @estimates = Estimate.all
  erb :documents
end

post '/invoices/:id/payments' do
  @invoice = Invoice.find(params[:id])
  @invoice.payments.create(
    payment_date: params[:payment_date],
    amount: params[:amount]
  )
  # 請求書のステータスを更新
  @invoice.update(status: 'paid')
  redirect "/invoices/#{@invoice.id}"
end

post '/invoices/:id/update' do
  @invoice = Invoice.find(params[:id])
  @invoice.update(status: params[:status])
  redirect "/invoices/#{@invoice.id}"
end

put '/invoices/:id' do
  @invoice = Invoice.find(params[:id])
  @invoice.update(
    issue_date: params[:issue_date],
    due_date: params[:due_date],
    subject: params[:subject],
    amount: params[:amount],
    status: params[:status],
    direction: params[:direction]
  )
  redirect "/invoices/#{@invoice.id}"
end

get '/estimates/:id' do
  @estimate = Estimate.find(params[:id])
  erb :estimate_show
end

get '/estimates/:id/edit' do
  @estimate = Estimate.find(params[:id])
  erb :estimate_edit
end

post '/estimates/:id/update' do
  @estimate = Estimate.find(params[:id])
  @estimate.update(status: params[:status])
  redirect "/estimates/#{@estimate.id}"
end

put '/estimates/:id' do
  @estimate = Estimate.find(params[:id])
  @estimate.update(
    issue_date: params[:issue_date],
    expiry_date: params[:expiry_date],
    subject: params[:subject],
    amount: params[:amount],
    status: params[:status],
    direction: params[:direction]
  )
  redirect "/estimates/#{@estimate.id}"
end