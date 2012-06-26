# -*- encoding: UTF-8 -*-
require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

describe Amebablog::Base do
  describe "を初期化する場合" do
    it "渡したUsernameが取得できる" do
      targ = Amebablog::Base.new("<username>", "<password>")
      targ.username.should == "<username>"
    end
  end
end
