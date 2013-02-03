# Copyright (c) 2012-2013 Stark & Wayne, LLC

require File.expand_path("../../spec_helper", __FILE__)

describe Bosh::Bootstrap do
  include FileUtils

  before do
    ENV['MANIFEST'] = File.expand_path("../../../tmp/test-manifest.yml", __FILE__)
    rm_rf(ENV['MANIFEST'])
    @cmd = Bosh::Bootstrap::Cli.new
  end

  describe "micro_bosh_stemcell_name" do
    # The +bosh_stemcells_cmd+ has an output that looks like:
    # +-----------------------------------+--------------------+
    # | Name                              | Tags               |
    # +-----------------------------------+--------------------+
    # | micro-bosh-stemcell-aws-0.6.4.tgz | aws, micro, stable |
    # | micro-bosh-stemcell-aws-0.7.0.tgz | aws, micro, test   |
    # | micro-bosh-stemcell-aws-0.8.1.tgz | aws, micro, test   |
    # +-----------------------------------+--------------------+
    #
    # So to get the latest version for the filter tags,
    # get the Name field, reverse sort, and return the first item
    it "should return the latest stable stemcell by default for AWS" do
      @cmd.settings["bosh_provider"] = "aws"
      @cmd.should_receive(:`).
        with("bosh public stemcells --tags micro,aws").
        and_return(File.read(spec_asset("bosh/public_stemcells/aws_micro.out")))
      @cmd.micro_bosh_stemcell_name.should == "micro-bosh-stemcell-aws-0.8.1.tgz"
    end
  end

end