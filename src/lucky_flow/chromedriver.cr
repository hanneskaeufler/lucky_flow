require "file_utils"
require "http/client"

class LuckyFlow::Chromedriver
  private property process : Process
  getter log_io = IO::Memory.new

  private def initialize
    @process = start_chromedriver
  end

  def self.start
    new
  end

  private def start_chromedriver : Process
    Process.new(
      "#{__DIR__}/../../vendor/chromedriver-2.40-#{os}",
      ["--port=4444", "--url-base=/wd/hub"],
      output: log_io,
      error: STDERR,
      shell: true
    )
  end

  private def os
    os_name = IO::Memory.new
    Process.run("uname -a", shell: true, output: os_name, error: STDERR)

    if os_name.to_s.includes?("Darwin")
      "mac64"
    else
      "linux64"
    end
  end

  def stop
    process.kill unless process.terminated?
  end
end
