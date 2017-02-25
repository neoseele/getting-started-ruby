# Copyright 2015, Google, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "google/cloud/translate"

class TranslateBookTitleJob < ActiveJob::Base
  queue_as :default

  def perform book
    Rails.logger.info "[TranslateService] Translate book title" +
                      "#{book.id} #{book.title.inspect}"

    # Create Translate
    translate = Google::Cloud::Translate.new keyfile: "/opt/app/api_key.json"
    
    title_zh = translate.translate book.title, to: "zh", model: "nmt"
    title_ja = translate.translate book.title, to: "ja", model: "nmt"
    
    book.title_zh = title_zh.text
    book.title_ja = title_ja.text
    book.save
    
    Rails.logger.info "[TranslateService] (#{book.id}) Complete"
  end
end