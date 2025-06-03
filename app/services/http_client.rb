require "faraday"
require "faraday/retry"

class HttpClient
  def initialize(host:)
    @host = host
  end

  def get(path, params = {}, opts = {})
    handle_request http_request(
      method: :get,
      path: path,
      params: params,
      opts: opts
    )
  end

  def post(path, params = {}, opts = {})
    handle_request http_request(
      method: :post,
      path: path,
      params: params.to_json,
      opts: opts
    )
  end

  def put(path, params = {}, opts = {})
    handle_request http_request(
      method: :put,
      path: path,
      params: params.to_json,
      opts: opts
    )
  end

  def delete(path, params = {}, opts = {})
    handle_request http_request(
      method: :delete,
      path: path,
      params: params,
      opts: opts
    )
  end

  def handle_request(response)
    data = response.success? ? parse(response.body) : {}

    unless response.success?
      Rails.logger.error(
        path: response.env.url,
        status: response.status,
        method: response.env.method,
        data: data
      )
    else
      Rails.logger.info(
        path: response.env.url,
        status: response.status,
        method: response.env.method,
        data: data
      )
    end

    { success: response.success?, status: response.status, data: data }
  end

  def http_request(method:, path:, params: {}, opts: {})
    http_connection(opts).send(method, @host + path, params, opts)
  end

  def http_connection(opts = {})
    retry_max = opts.fetch(:retry_max) { 3 }
    retry_interval = opts.fetch(:retry_interval) { 0.05 }

    retry_options = {
      max: retry_max,
      interval: retry_interval,
      interval_randomness: 0.5,
      backoff_factor: 2
    }

    Faraday.new do |conn|
      conn.request :retry, retry_options

      conn.adapter ::Faraday.default_adapter
      conn.response :logger, Rails.logger
      conn.options.timeout = opts.fetch(:timeout) { 5 }
      conn.options.open_timeout = opts.fetch(:open_timeout) { 5 }

      conn.headers["Authorization"] = "Bearer #{opts.fetch(:token) { nil }}"
      conn.headers["Content-Type"] = opts.fetch(:content_type) { "application/json" }
    end
  end

  def log_retry_event(env, _retry_opts, tries_max, exception)
    Rails.logger.warn(
      error: exception.class,
      message: exception.message,
      url: env.url.to_s,
      method: env.method,
      retry_max: tries_max
    )
  end

  def parse(body)
    JSON.parse(body)
  rescue JSON::ParserError
    body
  end
end
