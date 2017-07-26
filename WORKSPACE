http_archive(
	name = "com_github_nelhage_boost",
	#sha256 = ""
	strip_prefix = "rules_boost-0838fdac246ef9362b80009b9dd2018b5378a5ed",
	type = "zip",
	urls = [
		"https://github.com/nelhage/rules_boost/archive/0838fdac246ef9362b80009b9dd2018b5378a5ed.zip"
	],
)

load("@com_github_nelhage_boost//:boost/boost.bzl", "boost_deps")
boost_deps()

git_repository(
    name = "protobuf",
    remote = "https://github.com/google/protobuf.git",
    tag = "v3.3.0rc1",
)

new_git_repository(
    name = "gtest",
    remote = "https://github.com/google/googletest.git",
    commit = "f7248d80eae141397d39cc4b6a2ae7333a1d4935",
    build_file = "gtest.BUILD",
)

new_http_archive(
    name = "eigen",
    url = "https://github.com/RLovelett/eigen/archive/aaaa8c33025952bc8ef8c5c946fe8ab9cf45bf5d.zip",
    strip_prefix = "eigen-aaaa8c33025952bc8ef8c5c946fe8ab9cf45bf5d",
    build_file = "eigen.BUILD",
)

new_git_repository(
    name = "cnn",
    remote = "https://github.com/clab/dynet.git",
    commit = "a23940c5dc48aca9e57b287c2b083bf1283ece02",
    build_file = "cnn.BUILD",
)

new_git_repository(
    name = "easyloggingpp",
    remote = "https://github.com/easylogging/easyloggingpp.git",
    commit = "f926802dfbde716d82b64b8ef3c25b7f0fcfec65",
    build_file = "easyloggingpp.BUILD",
)
