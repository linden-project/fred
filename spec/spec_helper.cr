TESTING = true

require "file_utils"
require "spec"
require "io/memory"
require "../src/fred"

def temp_filename
  Random::Secure.urlsafe_base64(4) + ".tmp"
end
