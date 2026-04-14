import { Namespace, Context } from "@ory/keto-namespace-types"

class profile_user implements Namespace {}

class tenancy_access implements Namespace {
  related: {
    member: (profile_user | tenancy_access)[]
    service: profile_user[]
  }
}

class service_loans implements Namespace {
  related: {
    owner: profile_user[]
    admin: profile_user[]
    operator: profile_user[]
    viewer: profile_user[]
    member: profile_user[]
    service: (profile_user | tenancy_access)[]

    granted_loan_product_view: (profile_user | service_loans)[]
    granted_loan_product_manage: (profile_user | service_loans)[]
    granted_loan_request_view: (profile_user | service_loans)[]
    granted_loan_request_manage: (profile_user | service_loans)[]
    granted_loan_request_submit: (profile_user | service_loans)[]
    granted_client_product_access_view: (profile_user | service_loans)[]
    granted_client_product_access_manage: (profile_user | service_loans)[]
    granted_loan_view: (profile_user | service_loans)[]
    granted_loan_manage: (profile_user | service_loans)[]
    granted_disbursement_view: (profile_user | service_loans)[]
    granted_disbursement_manage: (profile_user | service_loans)[]
    granted_repayment_view: (profile_user | service_loans)[]
    granted_repayment_manage: (profile_user | service_loans)[]
    granted_penalty_view: (profile_user | service_loans)[]
    granted_penalty_manage: (profile_user | service_loans)[]
    granted_restructure_view: (profile_user | service_loans)[]
    granted_restructure_manage: (profile_user | service_loans)[]
    granted_reconciliation_manage: (profile_user | service_loans)[]
    granted_collection_manage: (profile_user | service_loans)[]
    granted_portfolio_view: (profile_user | service_loans)[]
    granted_portfolio_export: (profile_user | service_loans)[]
  }

  permits = {
    loan_product_view: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.member.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.viewer.includes(ctx.subject) || this.related.granted_loan_product_view.includes(ctx.subject),
    loan_product_manage: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_loan_product_manage.includes(ctx.subject),

    loan_request_view: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.member.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.viewer.includes(ctx.subject) || this.related.granted_loan_request_view.includes(ctx.subject),
    loan_request_manage: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_loan_request_manage.includes(ctx.subject),
    loan_request_submit: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.member.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_loan_request_submit.includes(ctx.subject),

    client_product_access_view: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.member.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.viewer.includes(ctx.subject) || this.related.granted_client_product_access_view.includes(ctx.subject),
    client_product_access_manage: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_client_product_access_manage.includes(ctx.subject),

    loan_view: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.member.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.viewer.includes(ctx.subject) || this.related.granted_loan_view.includes(ctx.subject),
    loan_manage: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_loan_manage.includes(ctx.subject),

    disbursement_view: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.member.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.viewer.includes(ctx.subject) || this.related.granted_disbursement_view.includes(ctx.subject),
    disbursement_manage: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_disbursement_manage.includes(ctx.subject),

    repayment_view: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.member.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.viewer.includes(ctx.subject) || this.related.granted_repayment_view.includes(ctx.subject),
    repayment_manage: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_repayment_manage.includes(ctx.subject),

    penalty_view: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.member.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.viewer.includes(ctx.subject) || this.related.granted_penalty_view.includes(ctx.subject),
    penalty_manage: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_penalty_manage.includes(ctx.subject),

    restructure_view: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.member.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.viewer.includes(ctx.subject) || this.related.granted_restructure_view.includes(ctx.subject),
    restructure_manage: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_restructure_manage.includes(ctx.subject),

    reconciliation_manage: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_reconciliation_manage.includes(ctx.subject),

    collection_manage: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_collection_manage.includes(ctx.subject),

    portfolio_view: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.member.includes(ctx.subject) || this.related.operator.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.viewer.includes(ctx.subject) || this.related.granted_portfolio_view.includes(ctx.subject),
    portfolio_export: (ctx: Context): boolean =>
      this.related.admin.includes(ctx.subject) || this.related.owner.includes(ctx.subject) || this.related.service.includes(ctx.subject) || this.related.granted_portfolio_export.includes(ctx.subject),
  }
}
