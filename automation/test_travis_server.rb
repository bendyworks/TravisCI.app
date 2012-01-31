require 'sinatra'
require 'json'

repositories = [ {
    id: 10,
    description: "10 words of programatic awesomenesss",
    last_build_id: 101,
    last_build_number: "1",
    last_build_started_at: "2012-01-31T17:18:25Z",
    last_build_finished_at: nil,
    last_build_status: nil,
    last_build_language: nil,
    last_build_duration: nil,
    last_build_result: nil,
    slug: "Travis-ci/CITravis"
  },
  {
    id: 20,
    description: "A C library for product recommendations/suggestions using collaborative filtering (CF)",
    last_build_id: 201,
    last_build_number: "1",
    last_build_started_at: "2012-01-31T17:17:12Z",
    last_build_finished_at: "2012-01-31T17:17:29Z",
    last_build_status: 1,
    last_build_language: nil,
    last_build_duration: 17,
    last_build_result: 1,
    slug: "Jwaters/awesomesauce"
  },
  {
    id: 30,
    description: "Obviscated Other Otter",
    last_build_id: 301,
    last_build_number: "1",
    last_build_started_at: "2012-01-31T17:15:41Z",
    last_build_finished_at: "2012-01-31T17:15:58Z",
    last_build_status: 1,
    last_build_language: nil,
    last_build_duration: 17,
    last_build_result: 1,
    slug: "Hadupadupadup/yup"
  }
]

def json_get route, options={}, &block
  get route, options do
    content_type :json
    mime_type 'text/json'
    block.call.to_json
  end
end

json_get '/repositories.json' do
  repositories
end

json_get '/repositories/10/builds.json' do
  [{
      id: 103,
      repository_id: 10,
      number: "3",
      started_at: "2012-01-31T17:41:41Z",
      finished_at: "2012-01-31T17:42:06Z",
      duration: 45,
      result: 0,
      commit: "52ad0e2e46f8756207cd18b5aaac688358247141",
      branch: "master",
      message: "some message"
    },
    {
      id: 102,
      repository_id: 10,
      number: "2",
      started_at: "2012-01-31T17:37:37Z",
      finished_at: "2012-01-31T17:37:55Z",
      duration: 36,
      result: 1,
      commit: "47926bb5698caeba5f35e24cf1a58ae1bb7736b8",
      branch: "master",
      message: "some message"
    },
    {
      id: 101,
      repository_id: 10,
      number: "1",
      started_at: "2011-11-28T21:43:43Z",
      finished_at: "2011-11-28T21:43:59Z",
      duration: 31,
      result: 0,
      commit: "c1751ae23fc94f1f3c3cfa3648d8ec39847cf714",
      branch: "master",
      message: "some message"
    }
  ]
end

json_get '/repositories/20/builds.json' do
  [{
      id: 203,
      repository_id: 20,
      number: "1",
      started_at: "2012-01-31T17:41:41Z",
      finished_at: "2012-01-31T17:42:06Z",
      duration: 45,
      result: 0,
      commit: "52ad0e2e46f8756207cd18b5aaac688358247141",
      branch: "master",
      message: "some message"
    }
  ]
end

json_get '/repositories/30/builds.json' do
  [{
      id: 303,
      repository_id: 30,
      number: "3",
      started_at: "2012-01-31T17:41:41Z",
      finished_at: "2012-01-31T17:42:06Z",
      duration: 45,
      result: 0,
      commit: "52ad0e2e46f8756207cd18b5aaac688358247141",
      branch: "master",
      message: "some message"
    }
  ]
end

json_get '/builds/103.json' do
{
  id: 103,
  repository_id: 10,
  number: "3",
  started_at: "2012-01-31T17:41:41Z",
  finished_at: "2012-01-31T17:42:06Z",
  duration: 45,
  state: "finished",
  config: {
    language: "node_js",
    node_js: [
      0.4,
      0.6
    ],
    ".configured" => true
  },
  status: 0,
  result: 0,
  matrix: [
    {
      id: 110,
      repository_id: 10,
      number: "7.1",
      state: "finished",
      started_at: "2012-01-31T17:41:41Z",
      finished_at: "2012-01-31T17:42:06Z",
      config: {
        language: "node_js",
        node_js: 0.4,
        ".configured" => true
      },
      status: 0,
      result: 0,
      build_id: 605126,
      commit: "52ad0e2e46f8756207cd18b5aaac688358247141",
      branch: "master",
      message: "Fix dev dependencies for testint purposes",
      committed_at: "2012-01-31T17:39:27Z",
      committer_name: nil,
      committer_email: nil,
      author_name: "Diogo Resende",
      author_email: "dresende@thinkdigital.pt",
      compare_url: "https://github.com/dresende/node-toolkit/compare/47926bb...52ad0e2"
    },
    {
      id: 111,
      repository_id: 10,
      number: "7.2",
      state: "finished",
      started_at: "2012-01-31T17:41:41Z",
      finished_at: "2012-01-31T17:42:01Z",
      config: {
        language: "node_js",
        node_js: 0.6,
        ".configured" => true
      },
      status: 0,
      result: 0,
      build_id: 605126,
      commit: "52ad0e2e46f8756207cd18b5aaac688358247141",
      branch: "master",
      message: "Fix dev dependencies for testint purposes",
      committed_at: "2012-01-31T17:39:27Z",
      committer_name: nil,
      committer_email: nil,
      author_name: "Diogo Resende",
      author_email: "dresende@thinkdigital.pt",
      compare_url: "https://github.com/dresende/node-toolkit/compare/47926bb...52ad0e2"
    }
  ],
  commit: "52ad0e2e46f8756207cd18b5aaac688358247141",
  branch: "master",
  message: "some message",
  committed_at: "2012-01-31T17:39:27Z",
  committer_name: nil,
  committer_email: nil,
  author_name: "Diogo Resende",
  author_email: "dresende@thinkdigital.pt",
  compare_url: "https://github.com/dresende/node-toolkit/compare/47926bb...52ad0e2"
}
end

json_get '/jobs/110.json' do
{
  id: 110,
  repository_id: 10,
  number: "7.1",
  state: "finished",
  started_at: "2012-01-31T17:41:41Z",
  finished_at: "2012-01-31T17:42:06Z",
  config: {
    language: "node_js",
    node_js: 0.4,
    ".configured" => true
  },
  status: 0,
  log: "log line one\n",
  result: 0,
  build_id: 605126,
  commit: "52ad0e2e46f8756207cd18b5aaac688358247141",
  branch: "master",
  message: "Fix dev dependencies for testint purposes",
  committed_at: "2012-01-31T17:39:27Z",
  committer_name: nil,
  committer_email: nil,
  author_name: "Diogo Resende",
  author_email: "dresende@thinkdigital.pt",
  compare_url: "https://github.com/dresende/node-toolkit/compare/47926bb...52ad0e2"
}

end

json_get '/jobs/111.json' do
{
  id: 111,
  repository_id: 10,
  number: "7.2",
  state: "finished",
  started_at: "2012-01-31T17:41:41Z",
  finished_at: "2012-01-31T17:42:06Z",
  config: {
    language: "node_js",
    node_js: 0.4,
    ".configured" => true
  },
  status: 0,
  log: "log line one\nlog line two\n",
  result: 0,
  build_id: 605126,
  commit: "52ad0e2e46f8756207cd18b5aaac688358247141",
  branch: "master",
  message: "Fix dev dependencies for testint purposes",
  committed_at: "2012-01-31T17:39:27Z",
  committer_name: nil,
  committer_email: nil,
  author_name: "Diogo Resende",
  author_email: "dresende@thinkdigital.pt",
  compare_url: "https://github.com/dresende/node-toolkit/compare/47926bb...52ad0e2"
}

end
