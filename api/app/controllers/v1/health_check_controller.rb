class V1::HealthCheckController < ApplicationController
  # ECSデプロイ ヘルスチェック用
  def index
    head 200
  end
end
