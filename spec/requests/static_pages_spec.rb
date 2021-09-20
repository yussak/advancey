require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Bookworm' }

  describe 'GET /home' do
    it 'should get home' do
      get root_path
      expect(response).to have_http_status(200)
      expect(response.body).to match(/<title>ホーム \/ #{base_title}<\/title>/i)
    end
  end

  describe 'GET /about' do
    it 'should get about' do
      get about_path
      expect(response).to have_http_status(200)
      expect(response.body).to match(/<title>アプリ詳細 \/ #{base_title}<\/title>/i)
    end
  end

  describe 'GET /contact' do
    it 'should get contact' do
      get contact_path
      expect(response).to have_http_status(200)
      expect(response.body).to match(/<title>お問い合わせ \/ #{base_title}<\/title>/i)
    end
  end
end
