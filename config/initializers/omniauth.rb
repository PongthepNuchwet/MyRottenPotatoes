Rails.application.config.middleware.use OmniAuth::Builder do
    # provider :developer unless Rails.env.production?
    provider :twitter, 'xgcKe2QaGICp61r6m6g83gLLn', '0FY0gUKVNMuaDtjGj2K6eMH1JI1ugqJRTFQO1JmTxxDUeIgmVc'

  end