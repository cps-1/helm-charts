#!/bin/bash

# shellcheck disable=SC2223

set -euo pipefail

: ${CPS1_DOTNET_VERSION:="9.0"}

cat <<EOF > /etc/apt/sources.list.d/dotnet-ubuntu-backports-noble.sources
Types: deb
URIs: https://ppa.launchpadcontent.net/dotnet/backports/ubuntu/
Suites: noble
Components: main
Signed-By:
 -----BEGIN PGP PUBLIC KEY BLOCK-----
 .
 mQINBGWzzawBEAD0r2+MRyiDtGRmCZ+S15spTUY9/l/0bKIZp5S+WTfd1NlSzkCl
 +XYQa4cy9+jzeAgosiN0Brx8X1ohYo2uRc4+yEZaODpuR4X5roAabLEE9/R3n9XL
 HJ0pqLiieqmsHcICqMFNYLc7eG3ttN3knRRbKQBk/P6UpJhcWRIex4Oeo5RK5pS3
 zCJzRCwqf/rZFfcHgssXSXjDqnYONOuNNyxp0qHG3PG3WVUjnnjx3tWI33T/Qiat
 FNJh3wW3Y+wMuRUuB04DymVgVoFBB2xWu158GtpuKrFQ7xf3ZSD4JgcwCx2pXQ+E
 P7GEm+S7ARk1hnN4vto3oqg8h6QdVbjaO+E+u7snmneC0GPCLlj9cvrKnRXEwJag
 oj+t0g7sR8iSbjfnLxAAPfPRpHnLCk/NjtB6kASJxggUEsRe3mcO+9WgvF/w85np
 or0L+AvPSnnUxrLybwKLT+0TbSOA3CKGAOfSAqCS77hbRjdjuzSoh5O7IQUZOrJJ
 XzfKZylSbW/t1mSZbmLMxB3aD/HfDeWLS3JWOQVMDCGCVE9yh6P9X0B/5UEYp5mu
 nQ34rttqMCu9gBPR93f21kz3dUoA5m/OSkvqrAwqgarlPKdQnjcthJGI0l+xU1fI
 fqC3wDjYIgJ+DCGl7OyLW7htMj+ZY7eJbHHXN4AMAwDFQcicW42VVnrIVwARAQAB
 tCJMYXVuY2hwYWQgUFBBIGZvciAuTkVUIEAgQ2Fub25pY2FsiQJOBBMBCgA4FiEE
 RaPxJxWb6eUBeBHGISWxZOjl0/oFAmWzzawCGwMFCwkIBwIGFQoJCAsCBBYCAwEC
 HgECF4AACgkQISWxZOjl0/poJA//U5RZZxAAWxWGj9qyelawo7KecLWImcFUDcnI
 2mfQOB9havZYcOcjenYiJTxKoJ4lRQzGbA/ssGea07zRtdaP/pyWv6iWfVsX3Dvl
 hwetndbkllbUKoFEQndyxKuK+JBaM3YLDqUVJhJp3w5Jn2IqfnWkZnGf3vZWFCtY
 Alobynkqnv0EVX4FteHG+/T4ouTXCkJVwMtekDdCkYXOE7mWWcRW7KAeHq/wI85T
 HaWR6jWjhsF9U0wjludVGeeoL6F8FGaHxbTbn7pQR8Epz92hl9+tQkyxjtjuXDtj
 TWvI1buewpzHujk5AXknLabmuFCGl/AHxYB6i4briBvar0SRy3x9XszvMiEtb69V
 ApepUcG/PmlUb5X0KofDoQ7btS56HxPRnScOyWX/tUccod41s7Tsx5eGYTEcZjRh
 FBYgjqhnMkcFoEpFx9Wt2Z2cRpZXzc07uz3WAF8eb3QcOkFrwySogVDhdF+cHvGI
 RyD27ZbxEsQDIr2hCgOdDg/Cvz9uvN5WhiFL/xM82idIWfczF1rkFb9p6AxR9c26
 99oVl+UOLTSPlPmsgtDwOTwc0EYjspEit30BQWQUEN4VaQlGpGLJxshs8hGf57fq
 5i/EmixUuQvkThlBZIdSkAeFhwS0mnGmcOQmfCE/6hBqBCgDEDspJPW56SGOVZMo
 yRDdXGU=
 =zcgX
 -----END PGP PUBLIC KEY BLOCK-----
EOF

apt-get update
apt-get install -y "dotnet-sdk-${CPS1_DOTNET_VERSION}" "dotnet-runtime-${CPS1_DOTNET_VERSION}"

dotnet --version
