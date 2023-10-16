db.getCollection("mca").updateMany({},{$unset: {
    factorRate: "", discountFactorRate: "", useDiscountRate: "" ,
    "withdFreq": "", fundingType: "", achWithdrawalAmt: "", fundingAmountRequested: "",
    "status": "", "paymentStatus":"", "statusreasonid": ""
    }});
