require 'rails_helper'

RSpec.describe "SiteLayouts", type: :request do
  describe "GET home" do
    subject{get root_path}
    it "has layout links" do
      expect(subject).to render_template('static_pages/home')
      assert_select "a[href=?]", root_path
      assert_select "a[href=?]", about_path
      assert_select "a[href=?]", contact_path
    end
  end
end
