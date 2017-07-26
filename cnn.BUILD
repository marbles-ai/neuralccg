package(default_visibility = ["//visibility:public"])

cc_library(
    name = "cnn-lib",
    srcs = glob(["cnn/*.cc"], exclude=["cnn/cuda.cc"]),
    hdrs = glob(["cnn/*.h"]),
    #linkopts = ["-lm", "-lboost_serialization", "-lboost_system", "-lboost_filesystem"],
    linkopts = ["-lm"],
    deps = ["@easyloggingpp//:easyloggingpp-lib",
            "@eigen//:eigen-lib",
            "@boost//:serialization",
            "@boost//:system",
            "@boost//:filesystem",
    ]
)
