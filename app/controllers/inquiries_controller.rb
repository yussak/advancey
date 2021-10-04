class InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new
  end

  # newアクションから入力内容を受け取り、送信ボタンクリックでcreateアクションを実行
  def confirm
    @inquiry = Inquiry.new(inquiry_params)
    render :new if @inquiry.invalid?
  end

  # 入力内容に誤りがあった場合、入力内容を保持したまま前のページに戻れるようにする
  def back
    @inquiry = Inquiry.new(inquiry_params)
    render :new
  end

  # 実際に送信するアクションになります。
  # ここで初めて入力内容を保存します。
  # セキュリティーのためにも一定時間で入力内容の削除を行ってもいいかもしれません。
  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      InquiryMailer.send_mail(@inquiry).deliver_now
      InquiryMailer.thanks_mail(@inquiry).deliver_now
      redirect_to done_path
    else
      render :new
    end
  end

  # 送信完了画面
  def done; end

  private

  def inquiry_params
    params.require(:inquiry)
          .permit(:email,
                  :name,
                  :phone_number,
                  :subject,
                  :message)
  end
end
