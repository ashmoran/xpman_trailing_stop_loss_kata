module CelluloidHelpers
  def self.included(host)
    host.class_eval do
      let(:logger) { Logger.new(StringIO.new) }

      around(:each) do |example|
        original_logger = Celluloid.logger
        Celluloid.logger = logger
        example.run
        Celluloid.logger = original_logger
      end

      after(:all) do
        Celluloid.logger = nil
      end
    end
  end
end
