class InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new
  end

  # newアクションから入力内容を受け取り、送信ボタンクリックでcreateアクションを実行
  def confirm
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.invalid?
      flash[:danger] = '入力内容に不備があります。。'
      render :new
    end
  end

  # 入力内容に誤りがあった場合、入力内容を保持したまま前のページに戻れるようにする
  def back
    @inquiry = Inquiry.new(inquiry_params)
    render :new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      InquiryMailer.thanks_mail(@inquiry).deliver_now
      InquiryMailer.send_mail(@inquiry).deliver_now
      flash[:success] = '送信完了しました！！！'
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def inquiry_params
    params.require(:inquiry)
          .permit(:email,
                  :name,
                  :message)
  end
end
