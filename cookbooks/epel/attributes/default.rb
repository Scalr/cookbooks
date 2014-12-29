default["epel"]["version"] =
    if (node["platform_version"].to_f >= 6.0 and node["platform_version"].to_f < 7) or node["platform"] == "amazon"
        "6"
    elsif node["platform_version"].to_i == 7
        "7"
    else
        "5"
    end
