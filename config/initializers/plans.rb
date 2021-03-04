PLANS = JSON.parse(YAML::load_file("./plans.yml").to_json, object_class: OpenStruct)
PLANS_TITLES = JSON.parse(YAML::load_file("./plans.yml").to_json).keys

FREE_PLAN = PLANS.free
STARTER_PLAN = PLANS.starter
PRO_PLAN = PLANS.pro