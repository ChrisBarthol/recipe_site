CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: 'AKIAIEXP3RUZ3Q6R2DPA',
    aws_secret_access_key: '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',
    region: "us-west-2"
  }
  config.fog_directory = 'useyourfoodle'
end