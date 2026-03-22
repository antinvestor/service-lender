package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/pitabwire/util"

	fundingbusiness "github.com/antinvestor/service-lender/apps/funding/service/business"
	groupbusiness "github.com/antinvestor/service-lender/apps/group/service/business"
	opsbusiness "github.com/antinvestor/service-lender/apps/operations/service/business"
	"github.com/antinvestor/service-lender/pkg/clients"
)

// RegisterWorkflowCallbacks registers all workflow callback HTTP endpoints.
func RegisterWorkflowCallbacks(
	mux *http.ServeMux,
	grpBusiness groupbusiness.GroupBusiness,
	memBusiness groupbusiness.MembershipBusiness,
	tenBusiness groupbusiness.TenureBusiness,
	perBusiness groupbusiness.PeriodBusiness,
	lwBusiness fundingbusiness.LoanWindowBusiness,
	loBusiness fundingbusiness.LoanOfferBusiness,
	lfBusiness fundingbusiness.FundingAllocationBusiness,
	prBusiness opsbusiness.PaymentRoutingBusiness,
	toBusiness opsbusiness.TransferOrderBusiness,
	obBusiness opsbusiness.ObligationBusiness,
	platformClients *clients.PlatformClients,
) {
	// Group lifecycle callbacks
	mux.HandleFunc("POST /api/v1/groups/{id}/check-formation", handleCheckFormation(grpBusiness, memBusiness))
	mux.HandleFunc(
		"POST /api/v1/groups/{id}/welcome",
		handleWelcomeGroup(grpBusiness, memBusiness, tenBusiness, perBusiness, platformClients),
	)
	mux.HandleFunc(
		"POST /api/v1/groups/{id}/setup-ledger",
		handleSetupLedger(grpBusiness, memBusiness, platformClients),
	)
	mux.HandleFunc("POST /api/v1/groups/{id}/create-tenure", handleCreateTenure(tenBusiness))
	mux.HandleFunc(
		"POST /api/v1/groups/{id}/register-lender",
		handleRegisterLender(grpBusiness, memBusiness, platformClients),
	)
	mux.HandleFunc("POST /api/v1/groups/{id}/open-period", handleOpenPeriod(perBusiness))
	mux.HandleFunc("POST /api/v1/groups/{id}/evaluate-loan-window", handleEvaluateLoanWindow(lwBusiness, perBusiness))
	mux.HandleFunc(
		"POST /api/v1/groups/{id}/calculate-obligations",
		handleCalculateObligations(obBusiness, memBusiness),
	)
	mux.HandleFunc("POST /api/v1/groups/{id}/transition", handleGroupTransition(grpBusiness))

	// Period lifecycle callbacks
	mux.HandleFunc("POST /api/v1/periods/{id}/close", handleClosePeriod(perBusiness, memBusiness, obBusiness))

	// Membership callbacks
	mux.HandleFunc(
		"POST /api/v1/memberships/{id}/check-periodic-payment",
		handleCheckPeriodicPayment(memBusiness, obBusiness),
	)

	// Funding callbacks
	mux.HandleFunc("POST /api/v1/loan-windows/{id}/generate-offers", handleGenerateOffers(lwBusiness, loBusiness))
	mux.HandleFunc("POST /api/v1/loan-offers/{id}/source-funding", handleSourceFunding(loBusiness, lfBusiness))
	mux.HandleFunc(
		"POST /api/v1/loan-offers/{id}/create-loan-account",
		handleCreateLoanAccount(loBusiness, platformClients),
	)
	mux.HandleFunc("POST /api/v1/loan-accounts/{id}/generate-schedule", handleGenerateSchedule(platformClients))
	mux.HandleFunc("POST /api/v1/loan-accounts/{id}/disburse", handleDisburse(platformClients))

	// Payment routing callbacks
	mux.HandleFunc("POST /api/v1/payments/identify", handleIdentifyPayment(prBusiness))
	mux.HandleFunc("POST /api/v1/payments/{id}/allocate", handleAllocatePayment(prBusiness, toBusiness, obBusiness))
	mux.HandleFunc("POST /api/v1/transfer-orders/{id}/execute", handleExecuteTransferOrder(toBusiness))

	// Status check callbacks
	mux.HandleFunc("GET /api/v1/obligations/{id}/status", handleObligationStatus(obBusiness))
}

// --- Callback handler factories ---

// Each returns an http.HandlerFunc that:
// 1. Extracts path parameter {id} from request
// 2. Decodes optional JSON body
// 3. Calls business logic
// 4. Returns JSON response or error

func handleCheckFormation(
	grpBusiness groupbusiness.GroupBusiness,
	memBusiness groupbusiness.MembershipBusiness,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		groupID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "check-formation").WithField("group_id", groupID)

		result, err := grpBusiness.CheckFormation(ctx, groupID)
		if err != nil {
			log.WithError(err).Error("check formation failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, result)
	}
}

func handleWelcomeGroup(
	grpBusiness groupbusiness.GroupBusiness,
	memBusiness groupbusiness.MembershipBusiness,
	tenBusiness groupbusiness.TenureBusiness,
	perBusiness groupbusiness.PeriodBusiness,
	pc *clients.PlatformClients,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		groupID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "welcome-group").WithField("group_id", groupID)

		err := grpBusiness.WelcomeGroup(ctx, groupID)
		if err != nil {
			log.WithError(err).Error("welcome group failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
	}
}

func handleSetupLedger(
	grpBusiness groupbusiness.GroupBusiness,
	memBusiness groupbusiness.MembershipBusiness,
	pc *clients.PlatformClients,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		groupID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "setup-ledger").WithField("group_id", groupID)

		err := grpBusiness.SetupLedgerAccounts(ctx, groupID)
		if err != nil {
			log.WithError(err).Error("setup ledger failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
	}
}

func handleCreateTenure(tenBusiness groupbusiness.TenureBusiness) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		groupID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "create-tenure").WithField("group_id", groupID)

		tenure, err := tenBusiness.Open(ctx, groupID)
		if err != nil {
			log.WithError(err).Error("create tenure failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, tenure)
	}
}

func handleRegisterLender(
	grpBusiness groupbusiness.GroupBusiness,
	memBusiness groupbusiness.MembershipBusiness,
	pc *clients.PlatformClients,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		groupID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "register-lender").WithField("group_id", groupID)

		err := grpBusiness.RegisterWithLender(ctx, groupID)
		if err != nil {
			log.WithError(err).Error("register lender failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
	}
}

func handleOpenPeriod(perBusiness groupbusiness.PeriodBusiness) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		groupID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "open-period").WithField("group_id", groupID)

		period, err := perBusiness.Open(ctx, groupID)
		if err != nil {
			log.WithError(err).Error("open period failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, period)
	}
}

func handleEvaluateLoanWindow(
	lwBusiness fundingbusiness.LoanWindowBusiness,
	perBusiness groupbusiness.PeriodBusiness,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		groupID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "evaluate-loan-window").WithField("group_id", groupID)

		result, err := lwBusiness.Evaluate(ctx, groupID)
		if err != nil {
			log.WithError(err).Error("evaluate loan window failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, result)
	}
}

func handleCalculateObligations(
	obBusiness opsbusiness.ObligationBusiness,
	memBusiness groupbusiness.MembershipBusiness,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		groupID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "calculate-obligations").WithField("group_id", groupID)

		err := obBusiness.CalculateForGroup(ctx, groupID)
		if err != nil {
			log.WithError(err).Error("calculate obligations failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
	}
}

func handleGroupTransition(grpBusiness groupbusiness.GroupBusiness) http.HandlerFunc {
	type transitionReq struct {
		State  int32  `json:"state"`
		Reason string `json:"reason"`
	}
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		groupID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "group-transition").WithField("group_id", groupID)

		var req transitionReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "invalid request body", http.StatusBadRequest)
			return
		}

		err := grpBusiness.Transition(ctx, groupID, req.State, req.Reason)
		if err != nil {
			log.WithError(err).Error("group transition failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
	}
}

func handleClosePeriod(
	perBusiness groupbusiness.PeriodBusiness,
	memBusiness groupbusiness.MembershipBusiness,
	obBusiness opsbusiness.ObligationBusiness,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		periodID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "close-period").WithField("period_id", periodID)

		err := perBusiness.Close(ctx, periodID)
		if err != nil {
			log.WithError(err).Error("close period failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
	}
}

func handleCheckPeriodicPayment(
	memBusiness groupbusiness.MembershipBusiness,
	obBusiness opsbusiness.ObligationBusiness,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		membershipID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "check-periodic-payment").WithField("membership_id", membershipID)

		result, err := memBusiness.CheckPeriodicPayment(ctx, membershipID)
		if err != nil {
			log.WithError(err).Error("check periodic payment failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, result)
	}
}

func handleGenerateOffers(
	lwBusiness fundingbusiness.LoanWindowBusiness,
	loBusiness fundingbusiness.LoanOfferBusiness,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		windowID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "generate-offers").WithField("window_id", windowID)

		offers, err := loBusiness.GenerateForWindow(ctx, windowID)
		if err != nil {
			log.WithError(err).Error("generate offers failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, offers)
	}
}

func handleSourceFunding(
	loBusiness fundingbusiness.LoanOfferBusiness,
	lfBusiness fundingbusiness.FundingAllocationBusiness,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		offerID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "source-funding").WithField("offer_id", offerID)

		result, err := lfBusiness.SourceForOffer(ctx, offerID)
		if err != nil {
			log.WithError(err).Error("source funding failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, result)
	}
}

func handleCreateLoanAccount(
	loBusiness fundingbusiness.LoanOfferBusiness,
	pc *clients.PlatformClients,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		offerID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "create-loan-account").WithField("offer_id", offerID)

		result, err := loBusiness.CreateLoanAccount(ctx, offerID)
		if err != nil {
			log.WithError(err).Error("create loan account failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, result)
	}
}

func handleGenerateSchedule(pc *clients.PlatformClients) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		http.Error(w, "schedule generation must be triggered via loans service", http.StatusNotImplemented)
	}
}

func handleDisburse(pc *clients.PlatformClients) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		http.Error(
			w,
			"disbursement requires operations service - create a DISBURSEMENT transfer order",
			http.StatusNotImplemented,
		)
	}
}

func handleIdentifyPayment(prBusiness opsbusiness.PaymentRoutingBusiness) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		log := util.Log(ctx).WithField("handler", "identify-payment")

		var req map[string]interface{}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "invalid request body", http.StatusBadRequest)
			return
		}

		result, err := prBusiness.IdentifyPayment(ctx, req)
		if err != nil {
			log.WithError(err).Error("identify payment failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, result)
	}
}

func handleAllocatePayment(
	prBusiness opsbusiness.PaymentRoutingBusiness,
	toBusiness opsbusiness.TransferOrderBusiness,
	obBusiness opsbusiness.ObligationBusiness,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		paymentID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "allocate-payment").WithField("payment_id", paymentID)

		result, err := prBusiness.AllocatePayment(ctx, paymentID)
		if err != nil {
			log.WithError(err).Error("allocate payment failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, result)
	}
}

func handleExecuteTransferOrder(toBusiness opsbusiness.TransferOrderBusiness) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		orderID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "execute-transfer-order").WithField("order_id", orderID)

		err := toBusiness.Execute(ctx, orderID)
		if err != nil {
			log.WithError(err).Error("execute transfer order failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
	}
}

func handleObligationStatus(obBusiness opsbusiness.ObligationBusiness) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		obligationID := r.PathValue("id")
		log := util.Log(ctx).WithField("handler", "obligation-status").WithField("obligation_id", obligationID)

		status, err := obBusiness.GetStatus(ctx, obligationID)
		if err != nil {
			log.WithError(err).Error("get obligation status failed")
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		writeJSON(w, http.StatusOK, status)
	}
}

// writeJSON writes a JSON response.
func writeJSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(data) //nolint:errcheck
}
