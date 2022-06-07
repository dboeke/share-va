resource "turbot_file" "vaec_approved_tenants" {
  parent  = "tmod:@turbot/turbot#/"
  title   = "VAEC Approved Tenant Accounts"
  akas = ["vaectenant"]
  content = <<-EOT
    {
      "018743596699": {
        "AWG20220506003":"777"
      },
      "037453786176": {
        "AWG20210809001":"1206",
        "AWG20220415004":"1199"
      },
      "659485066229": {
        "AWG20190128001":"93",
        "AWG20200918001":"839"
      },
      "311421544014": {
        "AWG20190715002":"519",
        "AWG20220310001":"1356",
        "AWG20220310002":"1400",
        "AWG20220318001":"1402",
        "AWG20220318002":"1403",
        "AWG20220318004":"1404",
        "AWG20220318006":"1405",
        "AWG20220318008":"1406",
        "AWG20220318007":"1407",
        "AWG20220318005":"1408",
        "AWG20220318009":"1409",
        "AWG20220318003":"1410",
        "AWG20181017004":"1412",
        "AWG20220502105":"1428",
        "AWG20220502104":"1443",
        "AWG20220502101":"1444",
        "AWG20220502102":"1446",
        "AWG20220502103":"1447"
      },
      "477194928391": {
        "AWG20170915001":"763",
        "AWG20170915001.1":"763.1",
        "AWG20170915001.2":"763.2"
      },
      "261727212250": {
        "AWG20210805002": "203",
        "AWG20210907002": "1357",
        "AWG20210810001": "1358",
        "AWG20210810002": "1359",
        "AWG20190820003": "1360",
        "AWG20200205001": "1361",
        "AWG20210905001": "1362",
        "AWG20211101001": "1363",
        "AWG20190920001": "1364",
        "AWG20200426001": "1365",
        "AWG20191115001": "1366",
        "AWG20201125001": "1367",
        "AWG20190225001": "1368",
        "AWG20210909002": "1369",
        "AWG20210728002": "1370",
        "AWG20210728003": "1371",
        "AWG20211009001": "1372",
        "AWG20210423001": "1373",
        "AWG20210518002": "1374",
        "AWG20211014001": "1375",
        "AWG20200728001": "1376",
        "AWG20190928001": "1377",
        "AWG20211003001": "1378",
        "AWG20210521001": "1379",
        "AWG20210423002": "1380",
        "AWG20210423003": "1381",
        "AWG20200725001": "1382",
        "AWG20181115002": "1383",
        "AWG20190820004": "1384",
        "AWG20181115003": "1385",
        "AWG20210328001": "1386",
        "AWG20211101002": "1387",
        "AWG20211205001": "1388",
        "AWG20180820002": "1389",
        "AWG20180820003": "1390",
        "AWG20211210001": "1391",
        "AWG20211215001": "1392"
      },
      "532813628429": {
        "AWG20210805002": "203",
        "AWG20210907002": "1357",
        "AWG20210810001": "1358",
        "AWG20210810002": "1359",
        "AWG20190820003": "1360",
        "AWG20200205001": "1361",
        "AWG20210905001": "1362",
        "AWG20211101001": "1363",
        "AWG20190920001": "1364",
        "AWG20200426001": "1365",
        "AWG20191115001": "1366",
        "AWG20201125001": "1367",
        "AWG20190225001": "1368",
        "AWG20210909002": "1369",
        "AWG20210728002": "1370",
        "AWG20210728003": "1371",
        "AWG20211009001": "1372",
        "AWG20210423001": "1373",
        "AWG20210518002": "1374",
        "AWG20211014001": "1375",
        "AWG20200728001": "1376",
        "AWG20190928001": "1377",
        "AWG20211003001": "1378",
        "AWG20210521001": "1379",
        "AWG20210423002": "1380",
        "AWG20210423003": "1381",
        "AWG20200725001": "1382",
        "AWG20181115002": "1383",
        "AWG20190820004": "1384",
        "AWG20181115003": "1385",
        "AWG20210328001": "1386",
        "AWG20211101002": "1387",
        "AWG20211205001": "1388",
        "AWG20180820002": "1389",
        "AWG20180820003": "1390",
        "AWG20211210001": "1391",
        "AWG20211215001": "1392"
      },
      "621261082401": {
        "AWG20210805002": "203",
        "AWG20210907002": "1357",
        "AWG20210810001": "1358",
        "AWG20210810002": "1359",
        "AWG20190820003": "1360",
        "AWG20200205001": "1361",
        "AWG20210905001": "1362",
        "AWG20211101001": "1363",
        "AWG20190920001": "1364",
        "AWG20200426001": "1365",
        "AWG20191115001": "1366",
        "AWG20201125001": "1367",
        "AWG20190225001": "1368",
        "AWG20210909002": "1369",
        "AWG20210728002": "1370",
        "AWG20210728003": "1371",
        "AWG20211009001": "1372",
        "AWG20210423001": "1373",
        "AWG20210518002": "1374",
        "AWG20211014001": "1375",
        "AWG20200728001": "1376",
        "AWG20190928001": "1377",
        "AWG20211003001": "1378",
        "AWG20210521001": "1379",
        "AWG20210423002": "1380",
        "AWG20210423003": "1381",
        "AWG20200725001": "1382",
        "AWG20181115002": "1383",
        "AWG20190820004": "1384",
        "AWG20181115003": "1385",
        "AWG20210328001": "1386",
        "AWG20211101002": "1387",
        "AWG20211205001": "1388",
        "AWG20180820002": "1389",
        "AWG20180820003": "1390",
        "AWG20211210001": "1391",
        "AWG20211215001": "1392"
      }
    }
    EOT
}

resource "turbot_file" "vaec_env_tag_values" {
  parent  = "tmod:@turbot/turbot#/"
  title   = "VAEC Environment Tag Values"
  akas = ["envtagvalues"]
  content = <<-EOT
    {
      "Production":"Production",
      "Stage":"Stage",
      "Development":"Development",
      "Demo":"Development",
      "demo":"Development",
      "DEV":"Development",
      "Dev":"Development",
      "dev":"Development",
      "DEV02":"Development",
      "Dev02":"Development",
      "dev8":"Development",
      "DEVELOPMENT":"Development",
      "development":"Development",
      "Development ":"Development",
      "Development2":"Development",
      "Development-2":"Development",
      "Development-A":"Development",
      "Development-CST":"Development",
      "Development-SBX":"Development",
      "devl":"Development",
      "devperf":"Development",
      "dev-shared":"Development",
      "DEVTEST":"Development",
      "DR Sandbox":"Development",
      "dr-dev":"Development",
      "fti-dev":"Development",
      "ivs-sandbox":"Development",
      "ldx-dev":"Development",
      "map-sandbox":"Development",
      "pexip-dev":"Development",
      "POC":"Development",
      "poc":"Development",
      "QA":"Development",
      "qa":"Development",
      "SANDBOX":"Development",
      "Sandbox":"Development",
      "sandbox":"Development",
      "SQA":"Development",
      "sqa":"Development",
      "SQA1":"Development",
      "SQA2":"Development",
      "SQA3":"Development",
      "SQA3C":"Development",
      "SQA4":"Development",
      "SQA5":"Development",
      "SQA6":"Development",
      "SQA7":"Development",
      "Test":"Development",
      "test":"Development",
      "Testing":"Development",
      "tst":"Development",
      "UAT":"Development",
      "uat":"Development",
      "UAT01":"Development",
      "UAT02":"Development",
      "UAT03":"Development",
      "aip-prod":"Production",
      "dr-prod":"Production",
      "fti-prod":"Production",
      "ivs-prod":"Production",
      "map-prod":"Production",
      "prd":"Production",
      "PROD":"Production",
      "Prod":"Production",
      "prod":"Production",
      "prod8":"Production",
      "Prod-A":"Production",
      "prod-aux":"Production",
      "prod-gov-internal":"Production",
      "Prod-Ops":"Production",
      "prod-shared":"Production",
      "Produciton":"Production",
      "PRODUCTION":"Production",
      "production":"Production",
      "Production-2":"Production",
      "Production-A":"Production",
      "Production-AUX":"Production",
      "Production-BCK":"Production",
      "Production-CM":"Production",
      "Production-CST":"Production",
      "Production-K":"Production",
      "Production-L":"Production",
      "Production-VPX":"Production",
      "DR-PreProd":"Stage",
      "fti-stage":"Stage",
      "ivs-staging":"Stage",
      "map-staging":"Stage",
      "Pre Production":"Stage",
      "PREPROD":"Stage",
      "PreProd":"Stage",
      "preprod":"Stage",
      "Pre-Prod":"Stage",
      "pre-prod":"Stage",
      "PreProduction":"Stage",
      "Pre-Production":"Stage",
      "STAGE":"Stage",
      "stage":"Stage",
      "stage8":"Stage",
      "Stage-A":"Stage",
      "Stage-CST":"Stage",
      "Stage-K":"Stage",
      "Stage-L":"Stage",
      "Stage-Ops":"Stage",
      "STAGETEST":"Stage",
      "StageTest":"Stage",
      "STAGING":"Stage",
      "Staging":"Stage",
      "staging":"Stage"
    }
    EOT
}