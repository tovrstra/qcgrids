#!/usr/bin/env python

template_dict = {
    "TPL_ANACONDA_TOKEN": "k4XK37vv/8HySKJXZmGIXRX+DRt1ZBRSc8M7pYCH3nrYuuO65o6Hziphe1JB/mxp8499aNe008dDPsRSvSHGA/IaNjHfNetok13navlSdfKABzQfENJbRtuFlKq/zC6/pAIAUqqm3LCcMs7kM+2cqIUVv4QIhPhq/HK6TneUWqi0wA9Rg3DavUbAinh1BnxA/f+8he2vZNgsRUfuB4nHpZ3mAPzuwGepQwGpi7eM5CApYfTG7ovlwFXAtaZiyQUxyIuq8E5l2X7RSWlzZ2w+xVJYPFF5B5g/p73U8C2xBxaid3VfXULKxLhXeDRHgpeOVxDZjscekH1Cac+53PDNcIamXPXzgNg4cIWr7OvL/KiWvnIIXO5nsrEUjCWrLiqXyzgbLZZBcBRySQ9CUe5jLNhxI6se1J3Qo7BWnFkPcNELxkUcZyTvZ96DBo7QiDYodE3SDVAtLRxTfpCqea/L3kTvNGlF9bNc5dA8427gAB5sb8FuhEliXArrtet3EK9fYfiaXoiIMJKwxVb7ydu43W/9f986TglGN0pk3tLX0Qg2jsHsyArshSZQJCiNH99KHJnkTwDmYiL2KnBHePHEkILNWpXE4pbwkW9JymQnwVhhmAseXDT+MKC3yyohfkP4wfbzmiNpQ5AKjEpDqx6cI51dh+PL4jfOW3Yct1MSrC4=",
    "TPL_GITHUB_TOKEN": "XlRLGJwV1vIaoLRxkd+ISQIKT4+PAPA4Pt8qVlvZ6pNM5v4PpS1t/xoPS0SH+LfPuB+EwjH/yLksM48DA/ZZwsFIUKd6bEjCroaIYwq0xf1d4TirT6n+wjq8HAD8zmO/GA8R6CAjbqBD35ORKxgviVe9j70DtE+aNdnPPYgBz8uJ5EY4MxOW7swTamIV7YAtu+pXKmVT375eB5Kg33Wd16kF9nRSnOS3UuDnK3dovMTPXtQ1dVSiUM37CcJXqXEFYsKXtvxVXJe96XBkj9lkCEVrGV7MWnUtnJKFdXRwuQf2BsdvGrtZWBiJq3XwK6B0nQv8hFYaXeg0PQcnJs/51MrXrVacXWkqs8fFkil0gf9XSAovkEVXn/s/WHKj/JDRnNU6kM7MeIRSY38Rt9VM9K/UzYj8BlkkdCMqWxdDu60a9H6AKmbrz+loWQqB6OAmP/wdsAlG2GH57e3BRY4wno1l4zED3/MmswNOaregy0SEWvtspUzi6foiqw4jh5TM7+wCfe32i2YpLwjIIzJMhNDph2VWch2I9Gcz/i8aQG3Ee7O9miU8Uvcrf8IgBoTtsBf4LiN8JM/ng8jLnGQHWcouwDClziivJs3IOwIVqotqoScbVTaU1NjZuY5cawAS9t/pZ6/h/KLtjMVOnFtYbZA+dz3KnFZtj9BZXLLw7vs=",
    "PROJECT_NAME": "qcgrids",
    "PYDIR": "python-qcgrids",
    "CONDA_PKG_NAME_CPP": "qcgrids",
    "CONDA_PKG_NAME_PY": "python-qcgrids",
    "GITHUB_REPO_NAME": "theochem/qcgrids",
    "TPL_DEPENDENCIES": "-c theochem cellcutoff python-cellcutoff"}

import sys
from string import Template

template_fn = sys.argv[1]

with open(template_fn) as fh:
    l = fh.read()

t = Template(l)
s = t.safe_substitute(**template_dict)
with open(".travis.yml", "w") as fh:
    fh.write(
        "#\n# THIS FILE IS AUTOGENERATED. DO NOT EDIT DIRECTLY. CHANGES IN \".travis.yml.tpl\" INSTEAD.\n#\n")
    fh.write(s)