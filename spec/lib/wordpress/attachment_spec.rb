require 'spec_helper'

describe Refinery::WordPress::Attachment, :type => :model do
  let(:attachment) { test_dump.attachments.first }

  specify { attachment.title.should == '200px-Tux.svg' }
  specify { attachment.description.should == 'Tux, the Linux mascot' }
  specify { attachment.url.should == 'http://localhost/wordpress/wp-content/uploads/2011/05/200px-Tux.svg_.png' }
  specify { attachment.file_name.should == '200px-Tux.svg_.png' }
  specify { attachment.post_date.should == DateTime.new(2011, 6, 5, 15, 26, 51) }
  specify { attachment.should be_an_image }

  describe "#to_refinery" do
    before do
      @image = attachment.to_refinery
    end

    it "should create an Image from the Attachment" do
      @image.should be_a(Image)
    end

    it "should copy the attributes from Attachment" do
      @image.created_at.should == attachment.post_date
      @image.image.url.end_with?(attachment.file_name).should be_true
    end
  end

  describe "#replace_image_url" do
    before do
      test_dump.authors.each(&:to_refinery)
      test_dump.posts.each(&:to_refinery)
      @image = attachment.to_refinery

      attachment.replace_image_url_in_blog_posts
    end

    it "should replace attachment urls in the generated BlogPosts" do
      BlogPost.first.body.should_not include(attachment.url)
      BlogPost.first.body.should include(@image.image.url)
    end

  end
end