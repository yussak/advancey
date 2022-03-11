class V1::TopicsController < ApplicationController
  def index
    topics = Topic.all
    render json: topics, methods: [:image_url] # 多分url取得できてない
    # render json: topics.to_json(methods: [:image_url])だとserializerが読まれず→username表示できなかった
    # to_jsonが悪そう
  end

  def create
    topic = Topic.new(topic_params)
    if topic.save
      render json: topic, methods: [:image_url]
    else
      render json: topic.errors
    end
  end

  def destroy
    topic = Topic.find(params[:id])
    render json: topic if topic.destroy
  end

  def show
    topic = Topic.find(params[:id])
    # 質問詳細ページでユーザー名・画像URLを取得しようとしてハマってる
    # ユーザー名だけ表示、画像URLだけ表示はできるが両方ともやるのができない
    # jsonの得る方法書ければ解決しそう

    # こっちはユーザー名は出るが画像が出ない
    # topicserializerが実行されてユーザー名が取得できるが、image_urlが実行されず画像URLが得られない
    # render json: topic, methods: :image_url

    # --------------------------------------------------------------------------------------------------------------------------

    # こっちは画像は出るがユーザー名が出ない
    # as_jsonつかうとserializerが動かないのでユーザー名得られない。でもimage_urlは動くので画像は表示できる

    # serliazer動けばuserのjson得られなくてもユーザー名は表示できたが、それだとimage_urlが動かない
    # →両方動かすためにinclude userしてみたが変わらず

    # これだとuserのname,image_urlどっちもjson取得できてるのでそれを渡せれば行けそうだが
    # render json: topic.as_json(include: [:user], methods: :image_url)

    # render json: topic.as_json(include: [:user], adapter: :json, methods: :image_url, serializer: TopicSerializer)

    # render json: topic.as_json(include: [{ user: [:name] }], methods: :image_url)

    # render json: topic.as_json(include: [:user])

    # render json: topic.as_json(methods: [:image_url])
    # render json: topic.as_json(methods: :image_url)

    # as_jsonの方でserializer動かせないか調べる
  end

  def edit
    topic = Topic.find(params[:id])
    render json: topic
  end

  def update
    topic = Topic.find(params[:id])
    if topic.update(topic_params)
      render json: topic
    else
      render json: topic.errors
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:user_id, :title, :content, :solve_status, :image) # 投稿のためにuser_id必要
  end
end
