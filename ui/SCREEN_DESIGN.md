# Lender UI — Screen Design Specification

> Product-driven lending UI for field agents, credit teams, and management.
> Every KYC field, document requirement, eligibility rule, and verification
> checklist is defined per loan product — no hardcoded forms.

## Design Principles

1. **Product drives everything** — `kyc_schema`, `required_documents`,
   `eligibility_criteria`, `fee_structure`, and `properties` on `LoanProductObject`
   control what data is collected, what documents are required, and how the
   application pipeline behaves.
2. **Role-adaptive** — each screen shows actions and data appropriate to the
   user's role (agent, verifier, approver, manager, admin).
3. **Offline-first for field agents** — client onboarding, KYC capture, and
   photo evidence use Drift local storage with background sync.
4. **Cross-entity navigation** — Client → Applications → Loans form a
   navigable chain. Every ID link is tappable.
5. **Progressive disclosure** — summaries first, detail on demand. No
   information overload on initial view.
6. **Production-ready** — pagination, search debounce, idempotent writes,
   optimistic UI, error boundaries per section.

---

## Proto Flexibility Points (existing)

These Struct fields on `LoanProductObject` are the configuration backbone:

| Field                  | Purpose                                    |
|------------------------|--------------------------------------------|
| `kyc_schema`           | JSON array of field definitions for KYC form |
| `required_documents`   | Array of document type strings              |
| `eligibility_criteria` | Rules evaluated before application creation |
| `fee_structure`        | Detailed fee breakdown by component         |
| `properties`           | Catch-all; includes `direct_borrower` flag  |

`ApplicationObject.kyc_data`, `VerificationTaskObject.checklist/results`,
and `UnderwritingDecisionObject.scoring_details/conditions` are all Struct
fields that store product-driven runtime data.

### KYC Schema Field Format

Each entry in the `kyc_schema` array:

```json
{
  "key": "monthly_income",
  "label": "Monthly Income",
  "type": "number",
  "required": true,
  "group": "financial",
  "hint": "Gross monthly income in KES",
  "options": null
}
```

Supported types: `text`, `number`, `date`, `select`, `phone`, `photo`,
`location`, `boolean`.

Fields are grouped by the `group` value (personal, financial, employment,
documents) and rendered in sections.

### Eligibility Criteria Format

```json
[
  { "field": "age",              "op": ">=", "value": 18,  "blocking": true  },
  { "field": "monthly_income",   "op": ">=", "value": 5000,"blocking": true  },
  { "field": "employment_status","op": "in", "value": ["employed","self_employed","business_owner"], "blocking": false },
  { "field": "account_age_days", "op": ">=", "value": 30,  "blocking": false }
]
```

---

## A. Dashboard

**Route:** `/`

The dashboard adapts its content based on the logged-in user's role.

### A1. Agent Dashboard

Shown when role includes `agent`.

| Card                  | Data Source                                  | Tap Target             |
|-----------------------|----------------------------------------------|------------------------|
| My Clients            | `clientSearch(agentId: me)`                  | `/field/clients`       |
| Pending KYC           | Clients missing required KYC fields          | `/field/clients?kyc=incomplete` |
| My Applications       | `applicationSearch(agentId: me)` by status   | `/origination/applications` |
| Awaiting My Approval  | Applications in UNDERWRITING for this agent  | `/loans/approvals`     |
| My Active Loans       | `loanAccountSearch(agentId: me, status: ACTIVE)` | `/loans`          |
| Overdue Alerts        | Delinquent loans for this agent's clients    | `/loans?status=DELINQUENT` |

**Quick Actions:** Onboard Client, New Application, Sync Pending (badge).

**Recent Activity:** Last 10 actions by this agent (onboard, submit, etc.)
sourced from `loanStatusChangeSearch` and application status history.

### A2. Credit Team Dashboard

Shown when role includes `verifier` or `approver`.

| Card                  | Data Source                                  | Tap Target             |
|-----------------------|----------------------------------------------|------------------------|
| My Queue              | Tasks/decisions assigned to me               | `/origination/pending` |
| Pending Verification  | Applications in VERIFICATION status          | `/origination/pending` |
| Pending Underwriting  | Applications in UNDERWRITING status          | `/origination/pending` |
| Flagged Applications  | Applications with risk flags                 | `/origination/pending` |

### A3. Manager / Admin Dashboard

Shown when role includes `manager`, `admin`, or `owner`.

All six existing metric cards (Verification, Underwriting, Offers, Active
Loans, Disbursement, Delinquent) plus:

| Card                  | Data Source                                  |
|-----------------------|----------------------------------------------|
| Portfolio Summary     | Total outstanding principal, clients, agents |
| Agent Performance     | Top/bottom agents by volume and delinquency  |
| Product Performance   | Applications and loans per product           |

All existing quick actions remain.

---

## B. Client Management

### B1. Clients List Screen

**Route:** `/field/clients`

**Search:** By name, phone number, ID number (searches within properties).

**Filters:**
- Agent (dropdown, pre-selected to current user if agent role)
- State (CREATED, ACTIVE, INACTIVE)
- KYC status (Complete / Incomplete / Pending Review)

**Each card displays:**
- Initials avatar (or profile photo thumbnail if available)
- Client name
- Phone number (from `properties.phone`)
- Agent name (resolved from agent ID)
- KYC completeness indicator: green (complete), amber (partial), red (missing critical)
- Sync status icon (for offline-created records)

**Actions:**
- Tap card → Client Detail (B2)
- FAB → Client Onboard Flow (B3)
- Toolbar sync button with pending count badge

### B2. Client Detail Screen

**Route:** `/field/clients/:clientId`

Scrollable page with collapsible sections.

#### Header
- Large avatar (profile photo or initials)
- Name, state badge, agent name
- Phone, ID number
- Created date, last updated
- **Actions:** Edit Profile, New Application, Recapture Location

#### Section: KYC Information
- Labeled grid of all key-value pairs from `client.properties`:
  Full Name, DOB, Gender, ID Type + Number, Phone(s), Email,
  Physical Address, County/District, Employment Status, Employer,
  Business Type, Monthly Income, Next of Kin
- Each field: label, value, completion dot (green/red)
- **KYC completeness bar** — percentage of required fields filled
  (evaluated against the most demanding active product's `kyc_schema`)
- **Edit KYC button** → Dynamic KYC Form (B4)

#### Section: Documents & Evidence
- Grid of document thumbnails
- Each card: type label, thumbnail preview (or file icon), upload date,
  verification status badge
- **Add Document** → file picker
- **Take Photo** → camera
- Tap card → full-screen image viewer with metadata

#### Section: Location
- Address text (locality, province, country)
- GPS coordinates + accuracy
- Capture timestamp
- **Recapture Location** button

#### Section: Loan Applications
- List of applications for this client via `applicationSearch(clientId)`
- Each row: ID, product name, amount, status badge, date
- Tap → Application Detail (C3)
- **New Application** button

#### Section: Active Loans
- List of loans for this client via `loanAccountSearch(clientId)`
- Each row: ID, principal, outstanding balance, status, days past due
- Tap → Loan Detail (D2)

#### Section: Credit Profile
- System credit limit, agent credit limit, effective limit
- Currency
- **Request Limit Change** button (agents)

### B3. Client Onboard Flow

**Route:** `/field/clients/new` (multi-step wizard)

Works fully offline. Each step validates before allowing next.

**Step 1 — Basic Information:**
- Name (required)
- Phone number (required)
- ID type: National ID / Passport / Other
- ID number (required)
- Date of birth
- Gender
- Agent auto-filled from logged-in user

**Step 2 — Address & Location:**
- Physical address (free text)
- County / District / Sub-county
- Nearest landmark
- **Capture GPS** button → auto-fills coordinates + reverse-geocoded address
- Location preview card

**Step 3 — Financial Information:**
- Employment status: Employed / Self-Employed / Business Owner /
  Unemployed / Retired
- Employer name (conditional: shown if Employed)
- Business type (conditional: shown if Self-Employed or Business Owner)
- Monthly income estimate
- Next of kin: name + phone

**Step 4 — Documents & Photos:**
- Checklist derived from union of all active products' `required_documents`
- For each: camera capture or gallery pick, preview, retake
- Client portrait photo
- Business premises photo (if self-employed)
- Home photo (location evidence)

**Step 5 — Review & Submit:**
- Summary of all data
- Missing required fields highlighted amber
- **Save Locally** (Drift, offline)
- **Save & Sync** (if online, pushes to backend + Files service)

### B4. Dynamic KYC Form

**Route:** `/field/clients/:clientId/kyc?productId=xxx`
(or embedded within onboard and application flows)

Renders fields from a product's `kyc_schema` using the reusable
`DynamicForm` widget engine.

- Pre-fills from `client.properties`
- Groups fields by `group` value into collapsible sections
- Validates required fields
- On save: merges into `client.properties` via API

---

## C. Loan Origination

### C1. Loan Products Screen

**Route:** `/loans/products` (list) and `/loans/products/:productId` (detail)

#### List View (existing, enhanced)
- Search by name or code
- Each card: name, code, type badge, currency, rate, state badge
- Tap → Product Detail

#### Product Detail (new — tabbed)

**Tab 1: Product Terms**
All existing fields: name, code, description, product type, currency,
interest method, repayment frequency, min/max amounts, min/max terms,
rates, fees, grace period.

**Tab 2: KYC Schema**
- Table of field definitions: Key, Label, Type, Required, Group
- Add / remove / reorder fields
- Live preview of rendered form
- Each field: key, label, type dropdown, required toggle, group dropdown,
  hint text, options editor (for select type)

**Tab 3: Required Documents**
- Checklist of document types (National ID, Passport, Business Reg, etc.)
- Each toggleable on/off with Required vs Optional flag
- Custom document types can be added

**Tab 4: Eligibility Rules**
- Table of rules: Field, Operator, Value, Blocking
- Add / remove rules
- Operators: `>=`, `<=`, `==`, `!=`, `in`, `not_in`
- Blocking toggle: if true, failing this rule prevents application

**Tab 5: Fee Structure**
- Processing fee: flat or percentage
- Insurance fee: flat or percentage
- Late penalty: rate + type (flat daily / percentage of overdue)
- Early repayment fee
- Custom fee lines: name, type, value

**Tab 6: Workflow**
- Direct client product toggle (`properties.direct_borrower`)
- Verification types required (list of strings, e.g. "Site Visit",
  "Employment Check", "Guarantor Verification")
- Auto-approval ceiling: max amount that can be approved without
  manual underwriting

### C2. New Application Flow

**Route:** `/origination/applications/new`
(or launched from Client Detail with client pre-selected)

Multi-step wizard. Product selection drives subsequent steps.

**Step 1 — Select Product:**
- Cards for each product the client can access (via `ClientProductAccess`)
- Each card: name, amount range, term range, rate, type
- Products the client cannot access shown grayed with reason
  (no access, active loan, pending application)

**Step 2 — Eligibility Pre-check:**
- Evaluates product's `eligibility_criteria` against client data
- Each rule: description, pass/fail indicator, client's value vs required
- Blocking failures prevent proceeding (with explanation)
- Warnings allow proceeding (shown in amber)

**Step 3 — KYC Data (product-driven):**
- Renders product's `kyc_schema` via `DynamicForm`
- Pre-fills from `client.properties`
- Missing required fields highlighted
- Saves to `application.kyc_data` AND updates `client.properties`

**Step 4 — Documents (product-driven):**
- Checklist from product's `required_documents`
- Already-uploaded client documents shown with green check
- Missing documents: upload button (camera + gallery)
- Each upload creates `ApplicationDocumentObject`

**Step 5 — Loan Details:**
- Requested amount (slider + input, validated against product min/max
  and effective credit limit)
- Requested term in days (slider + input)
- Purpose (free text or product-configured dropdown)
- **Loan calculator** preview:
  - Monthly installment
  - Total interest
  - Total fees (itemized from `fee_structure`)
  - Total repayable
  - First 3 schedule entries

**Step 6 — Review & Submit:**
- Full summary: product, client, KYC completeness, document thumbnails,
  loan terms, calculator output, eligibility results
- **Save as Draft** (DRAFT status)
- **Submit Application** (triggers pipeline)
- For direct-client products: note "Routed to agent for approval"

### C3. Application Detail Screen

**Route:** `/origination/applications/:applicationId`

#### Header
- Status badge (large)
- **Status stepper:** DRAFT → SUBMITTED → KYC → DOCUMENTS → VERIFICATION
  → UNDERWRITING → OFFER → LOAN (current step highlighted, completed
  steps checked, future steps grayed)
- Client name (tappable → Client Detail)
- Product name (tappable → Product Detail)
- Agent name
- Amounts: requested / approved
- Dates: submitted, decided, offer expires (countdown if active)

#### Risk Assessment Card
Shown after submission. Overall pass/fail. Each flag as a chip:
severity color + code + message. Expandable details.

#### Tab 1: Application Details
- Loan parameters: amount, term, purpose, rate
- Calculator: installment, total interest, total fees, total repayable
- KYC data in labeled grid (from `application.kyc_data`)
- Fields differing from `client.properties` highlighted

#### Tab 2: Documents
- Product-driven checklist with status per document
- Each: thumbnail, type, date, verification status badge
- Tap → full preview
- **Verifier actions:** Verify / Reject (with reason)
- Document completeness meter

#### Tab 3: Verification
- Tasks auto-created per product's verification types
- Each card: type, assigned to, status badge, notes
- **Verifier actions:** Start (→ IN_PROGRESS), Complete (→ PASSED/FAILED)
- Checklist from `task.checklist` as toggleable checkboxes
- Results from `task.results` shown after completion
- Audit context: who completed, when, where (GPS)

#### Tab 4: Underwriting
- **Approver form:** outcome (Approve / Decline / Request More Info /
  Counter-Offer), credit score, risk grade, approved amount/term/rate,
  reason (required), scoring details, conditions
- Decision history list

#### Tab 5: Timeline
- Chronological log of all status changes, verification completions,
  underwriting decisions
- Each entry: timestamp, status transition, actor, reason

#### Action Bar (role-adaptive, bottom)
- **Agent:** Edit (DRAFT), Submit, Cancel
- **Verifier:** Complete Verification Task
- **Approver:** Make Underwriting Decision
- **Manager/Admin:** Accept Offer, Decline Offer, Cancel, Override Status

### C4. Pending Cases Screen

**Route:** `/origination/pending`

Three tabs: **Verification**, **Underwriting**, **Offers**.

Each tab has a **count badge**.

**Filters:**
- "Assigned to Me" toggle (default on for verifiers/approvers)
- Search by client name or application ID
- Product filter dropdown

**Each card shows:**
- Client name + product name
- Amount requested
- Days in current stage (color: green <2d, amber 2-5d, red >5d)
- Risk flag count badge
- Assigned person name
- Tap → Application Detail

**Manager extras:** Bulk assign, bulk re-queue actions.

---

## D. Loan Management

### D1. Loan Accounts Screen

**Route:** `/loans`

**Filters:**
- Status dropdown (all existing statuses)
- Agent dropdown (pre-selected for agent role)
- Client search
- Product dropdown

**Each card shows:**
- Client name (resolved)
- Product name
- Principal / outstanding balance
- Next payment: date + amount due
- Days past due (red if > 0)
- Status badge

**Summary bar:** Total Outstanding, Total Clients, Delinquency Rate %.

### D2. Loan Detail Screen

**Route:** `/loans/:loanId`

#### Header
- Client name (linked → Client Detail)
- Product name (linked → Product Detail)
- Agent, branch, bank
- Application link (→ Application Detail)
- Status badge
- Dates: disbursed, maturity, next payment

#### Balance Card
- Visual: donut chart (principal paid vs outstanding)
- Breakdown: Principal, Interest, Fees, Penalties
- Total Outstanding / Total Paid
- Percentage complete

#### Tab 1: Schedule
Columns: Period #, Due Date, Principal, Interest, Fees, Total Due,
Paid, Status. Color-coded rows: green (paid), amber (partial),
red (overdue), gray (upcoming). Running balance column.

#### Tab 2: Transactions
Unified timeline: disbursements, repayments, penalties, waivers.
Each: date, type icon, description, amount (+/-), running balance.
Filter by type.

#### Tab 3: Penalties
Active penalties: type, amount, reason, date.
Waived: amount, reason, waived by, date.
**Manager actions:** Add Penalty, Waive Penalty (with reason).

#### Tab 4: Restructuring
Original vs new terms comparison table (if restructured).
Request history. **Manager action:** Request Restructure (new terms form).

#### Tab 5: History
Status change timeline with actor and reason.

#### Action Bar (role-adaptive)
- **Manager:** Disburse, Record Payment, Collect Payment, Add Penalty,
  Waive Penalty, Request Restructure
- **Admin:** All manager actions + Write Off, Close

### D3. Agent Approval Screen

**Route:** `/loans/approvals`

For agents reviewing direct-client loan requests routed to them.

**Data source:** Applications where `agent_id` = current agent AND
`status` = UNDERWRITING AND product `direct_borrower` = true.

**Each card:**
- Client name + photo
- Product name + requested amount
- Risk assessment summary (pass/fail + flag count)
- Days waiting (urgency color)
- Tap → Application Detail (underwriting tab focused)

**Quick actions per card:**
- **Approve** — default amount, one-tap
- **Decline** — reason dialog
- **Counter-Offer** — adjust amount/term/rate form

---

## E. Cross-Cutting Components

### E1. File Upload Service

**Provider:** `filesServiceClientProvider` in `api_provider.dart`

**Reusable Upload Widget:**
- Camera capture (compress to 80% JPEG, max 2048px)
- Gallery picker
- Upload progress indicator
- Thumbnail preview after upload
- Returns `file_id` for linking
- **Offline:** stores file locally, queues for upload on sync

### E2. Dynamic Form Engine

**Widget:** `DynamicForm`

- **Input:** `List<Map<String, dynamic>>` from product `kyc_schema`
- **Output:** `Map<String, dynamic>` of values
- **Field types:** text, number, date, select, phone, photo, location,
  boolean
- **Features:** required validation, format validation (phone, ID
  patterns), section grouping by `group`, pre-fill from existing values
- **Rendering:** each group is a collapsible section header with fields
  below

### E3. Loan Calculator Widget

**Widget:** `LoanCalculator`

- **Input:** amount, term, rate, interest method, repayment frequency,
  fee structure
- **Output:** monthly installment, total interest, total fees (itemized),
  total repayable, amortization preview (first N entries)
- Uses the same calculation logic as the backend
  (`pkg/calculation/amortization.go` ported to Dart or called via API)

### E4. Status Stepper Widget

**Widget:** `ApplicationStatusStepper`

- Shows the full pipeline: DRAFT → SUBMITTED → KYC → DOCUMENTS →
  VERIFICATION → UNDERWRITING → OFFER → LOAN
- Current step highlighted with pulse animation
- Completed steps: green check
- Skipped steps (direct-client): dashed line
- Terminal states (REJECTED, CANCELLED, EXPIRED): red X at the step
  where it terminated

### E5. Entity Link Chips

**Widget:** `EntityChip`

- Renders a tappable chip with icon + label for cross-entity navigation
- Types: client, agent, product, application, loan
- Tap navigates to the entity's detail screen
- Used throughout headers and detail sections

---

## F. Navigation Structure

```
Dashboard (role-adaptive)                          /
  Field Operations
    Clients                                        /field/clients
      Client Detail                                /field/clients/:id
        KYC Form                                   /field/clients/:id/kyc
      Client Onboard                               /field/clients/new
    Agent Hierarchy                                /field/hierarchy
    Client Reassignment                            /field/reassignment
  Origination
    Pending Cases                                  /origination/pending
    Applications                                   /origination/applications
      Application Detail                           /origination/applications/:id
      New Application                              /origination/applications/new
  Loan Management
    Loan Products                                  /loans/products
      Product Detail                               /loans/products/:id
    Loan Accounts                                  /loans
      Loan Detail                                  /loans/:id
    Agent Approvals                                /loans/approvals
  Operations
    Transfer Orders                                /operations/transfers
  Organization
    Banks & Branches                               /organization/banks
      Bank Detail                                  /organization/banks/:id
    Investors                                      /organization/investors
  Administration
    System Users                                   /admin/users
    Roles & Permissions                            /admin/roles
    Audit Log                                      /admin/audit
  Settings                                         /settings
```

---

## G. Data Flow Summary

```
Product Configuration (admin)
  kyc_schema ──────────────→ Dynamic KYC Form (onboard + application)
  required_documents ──────→ Document checklist (onboard + application)
  eligibility_criteria ────→ Eligibility pre-check (application creation)
  fee_structure ───────────→ Loan calculator (application review)
  properties.direct_borrower → Routing: agent approval vs full pipeline
  verification_types ──────→ Auto-created verification tasks

Client Onboarding (agent, offline-capable)
  Basic info ──→ ClientObject fields
  KYC data ────→ ClientObject.properties (schema-validated)
  Documents ───→ Files service → document refs in properties
  Photos ──────→ Files service → file_ids in properties
  Location ────→ ClientObject.properties.location + audit_context

Loan Application (agent)
  Product selection ──→ loads kyc_schema + requirements
  Eligibility check ──→ evaluates criteria against client data
  KYC form ───────────→ application.kyc_data (product-driven)
  Documents ──────────→ ApplicationDocumentObjects (product-driven)
  Loan terms ─────────→ ApplicationObject fields
  Submit ─────────────→ triggers pipeline per product config

Verification Pipeline (credit team)
  Auto-creates tasks per product verification types
  Assigns to verifiers by queue or manual assignment
  Each task has product-driven checklist
  Completion triggers next stage transition

Underwriting (approver or agent for direct products)
  Reviews KYC data + risk flags + documents + verification results
  Makes decision: Approve / Decline / Counter-Offer
  If approved: offer generated with terms

Loan Lifecycle (manager)
  Offer accepted → Loan account created
  Disbursement → Payment recording → Schedule tracking
  Delinquency alerts → Collection → Restructure or Write-off
```

---

## H. Offline Strategy

Field agents operate in low-connectivity environments. The offline
strategy ensures they can do their core work without interruption.

**Offline-capable operations:**
- Client onboarding (all 5 steps)
- KYC data editing
- Photo capture and local storage
- GPS location capture
- Application draft creation

**Sync behavior:**
- Background sync attempts every 60 seconds when online
- Manual sync button with pending count badge
- Conflict resolution: last-write-wins with server timestamp
- Photos queued for upload, referenced by local path until synced
- Failed syncs: retry with exponential backoff, surface errors to user

**Drift tables:**
- `local_clients` — client records with sync status
- `local_documents` — file metadata + local path, pending upload
- `local_applications` — draft applications created offline

**Online-only operations:**
- Application submission (requires server-side validation)
- Verification task completion
- Underwriting decisions
- Loan disbursement / payment recording
- All operations involving external service calls

---

## I. Performance Considerations

- **Pagination:** All list screens use cursor-based pagination (existing
  `PageCursor` proto). Load 50 items at a time with infinite scroll.
- **Search debounce:** 400ms debounce on all search inputs to avoid
  excessive API calls.
- **Provider caching:** Riverpod providers cache results; manual
  invalidation on mutations.
- **Image optimization:** Photos compressed to 80% JPEG, max 2048px
  before upload. Thumbnails generated locally for list views.
- **Lazy tabs:** Tab content loads only when selected (not pre-loaded).
- **Background sync:** Runs in isolate to avoid blocking UI thread.
- **Error boundaries:** Each section in detail screens handles errors
  independently — one failed API call doesn't break the whole screen.
