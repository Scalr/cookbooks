default["scalarizr"]["behaviour"] = ["base"]
default["scalarizr"]["platform"]  = "ec2"
default["scalarizr"]["branch"] = "latest"
# Empty branch string also means we want latest
node.override["scalarizr"]["branch"] = "latest" if node["scalarizr"]["branch"].strip.empty?
