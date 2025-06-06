//
//  STPFixtures+Swift.swift
//  StripeiOSTests
//
//  Created by Yuki Tokuhiro on 3/22/23.
//

import Foundation
@testable@_spi(STP) import StripeCore
@testable@_spi(STP) import StripePayments

public extension STPFixtures {
    static func paymentMethodBillingDetails() -> STPPaymentMethodBillingDetails {
        let billingDetails = STPPaymentMethodBillingDetails()
        billingDetails.name = "Jane Doe"
        billingDetails.email = "foo@bar.com"
        billingDetails.phone = "5555555555"
        billingDetails.address = STPPaymentMethodAddress()
        billingDetails.address?.line1 = "510 Townsend St."
        billingDetails.address?.line2 = "Line 2"
        billingDetails.address?.city = "San Francisco"
        billingDetails.address?.state = "CA"
        billingDetails.address?.country = "US"
        billingDetails.address?.postalCode = "94102"
        return billingDetails
    }

    static func paymentIntent(
        paymentMethodTypes: [String],
        setupFutureUsage: STPPaymentIntentSetupFutureUsage = .none,
        paymentMethodOptionsSetupFutureUsage: [STPPaymentMethodType: String]? = nil,
        currency: String = "usd",
        status: STPPaymentIntentStatus = .requiresPaymentMethod,
        paymentMethod: [AnyHashable: Any]? = nil,
        nextAction: STPIntentActionType? = nil
    ) -> STPPaymentIntent {
        var apiResponse: [AnyHashable: Any] = [
            "id": "123",
            "client_secret": "sec",
            "amount": 2345,
            "currency": currency,
            "status": STPPaymentIntentStatus.string(from: status),
            "livemode": false,
            "created": 1652736692.0,
            "payment_method_types": paymentMethodTypes,
        ]
        if let setupFutureUsage = setupFutureUsage.stringValue {
            apiResponse["setup_future_usage"] = setupFutureUsage
        }
        if let paymentMethodOptionsSetupFutureUsage = paymentMethodOptionsSetupFutureUsage {
            var paymentMethodOptions: [String: Any] = [:]
            paymentMethodOptionsSetupFutureUsage.forEach { paymentMethodType, setupFutureUsage in
                paymentMethodOptions[paymentMethodType.identifier] = ["setup_future_usage": setupFutureUsage]
            }
            apiResponse["payment_method_options"] = paymentMethodOptions
        }
        if let paymentMethod = paymentMethod {
            apiResponse["payment_method"] = paymentMethod
        }
        if let nextAction = nextAction {
            apiResponse["next_action"] = ["type": nextAction.stringValue]
        }
        return STPPaymentIntent.decodedObject(fromAPIResponse: apiResponse)!
    }

    static func setupIntent(
        paymentMethodTypes: [String],
        status: STPSetupIntentStatus = .requiresPaymentMethod,
        paymentMethod: [AnyHashable: Any]? = nil,
        nextAction: STPIntentActionType? = nil
    ) -> STPSetupIntent {
        var apiResponse: [AnyHashable: Any] = [
            "id": "123",
            "client_secret": "sec",
            "status": STPSetupIntentStatus.string(from: status),
            "livemode": false,
            "created": 1652736692.0,
            "payment_method_types": paymentMethodTypes,
        ]

        if let paymentMethod = paymentMethod {
            apiResponse["payment_method"] = paymentMethod
        }
        if let nextAction = nextAction {
            apiResponse["next_action"] = ["type": nextAction.stringValue]
        }
        return STPSetupIntent.decodedObject(fromAPIResponse: apiResponse)!
    }

    static func usBankAccountPaymentMethod(bankName: String? = nil) -> STPPaymentMethod {
        var json = STPTestUtils.jsonNamed("USBankAccountPaymentMethod") as? [String: Any]
        if let bankName = bankName {
            var usBankAccountData = json?["us_bank_account"] as? [String: Any]
            usBankAccountData?["bank_name"] = bankName
            json?["us_bank_account"] = usBankAccountData
        }
        return STPPaymentMethod.decodedObject(fromAPIResponse: json)!
    }

    static func sepaDebitPaymentMethod() -> STPPaymentMethod {
        let json = STPTestUtils.jsonNamed("SEPADebitPaymentMethod")
        return STPPaymentMethod.decodedObject(fromAPIResponse: json)!
    }
}

public extension STPPaymentMethodParams {
    static func _testValidCardValue() -> STPPaymentMethodParams {
        return _testCardValue()
    }

    static func _testCardValue(number: String = "4242424242424242") -> STPPaymentMethodParams {
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = number
        cardParams.cvc = "123"
        cardParams.expYear = 2040
        cardParams.expMonth = 01
        return STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
    }

    static func _testSEPA() -> STPPaymentMethodParams {
        let sepaDebitParams = STPPaymentMethodSEPADebitParams()
        sepaDebitParams.iban =  "AT611904300234573201"

        let billingAddress = STPPaymentMethodAddress()
        billingAddress.city = "London"
        billingAddress.country = "GB"
        billingAddress.line1 = "Stripe, 7th Floor The Bower Warehouse"
        billingAddress.postalCode = "EC1V 9NR"

        let billingDetails = STPPaymentMethodBillingDetails()
        billingDetails.address = billingAddress
        billingDetails.email = "email@email.com"
        billingDetails.name = "Isaac Asimov"
        billingDetails.phone = "555-555-5555"

        return STPPaymentMethodParams(sepaDebit: sepaDebitParams, billingDetails: billingDetails, metadata: nil)
    }
}
