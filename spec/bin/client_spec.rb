# -*- encoding: UTF-8 -*-
require "spec_helper"

describe Amebablog::Client do
  describe "を初期化する場合" do
    it "UsernameとPasswordで認証が通ればUsernameが取得できる" do
      # 有効なUsernameとPasswordを使う
      targ = Amebablog::Client.new("<username>", "<password>")
      targ.username.should == "<username>"
    end
    it "md5変換したPasswordで認証が通ればUsernameが取得できる" do
      # 有効なUsernameとPasswordを使う
      targ = Amebablog::Client.new("<username>", Digest::MD5.hexdigest("<password>").downcase, true)
    end
    it "認証に失敗すると例外が発生する" do
      lambda{ Amebablog::Client.new("<username>", "<password>") }.should raise_error(RuntimeError)
    end
  end
end
