require 'spec_helper'

describe LogoUploader do

  include CarrierWave::Test::Matchers
  let(:shop) { FactoryGirl.create(:shop) }
  let(:path_to_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', '155x100.png') }

  before do
    LogoUploader.enable_processing = true
    @uploader = LogoUploader.new(shop, :logo)
    @uploader.store!(File.open(path_to_file))
  end

  after do
    LogoUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the small version' do
    it "should scale down a landscape image to fit within 200 by 80 pixels" do
      expect(@uploader).to be_no_larger_than(200, 200)
    end
  end

  it "should make the image readable only to the owner and not executable" do
    expect(@uploader).to have_permissions(0644)
  end

end
