-- ============================================================
--  Alpha Data – Employee Data Collection
--  Supabase Schema
--  Run this in: Supabase Dashboard → SQL Editor → New query
-- ============================================================

-- ──────────────────────────────────────────────────────────
--  TABLE 1: ehs_profiles  (Tab 1 – EHS / Engineering Profile)
-- ──────────────────────────────────────────────────────────
create table if not exists ehs_profiles (
  id                   uuid primary key default gen_random_uuid(),
  submitted_at         timestamptz default now(),

  -- Basic Info
  candidate_name       text,
  gender               text,
  personal_email       text,
  mobile               text,
  date_of_birth        date,
  marital_status       text,
  nationality          text,
  emirate              text,
  location             text,
  bilingual            text,

  -- Role & Skills
  role                 text,
  skill                text,
  reporting_to         text,
  exp_in_ehs_yrs       numeric,
  total_experience_yrs numeric,
  notice_period        text,

  -- Performance
  avg_csat_score       numeric,
  avg_fcr_pct          numeric,
  awards               text,

  -- Documents
  visa_expiry          date,
  passport_expiry      date,
  driving_license      text,
  license_no           text,
  license_country      text,
  license_expiry       date
);

-- ──────────────────────────────────────────────────────────
--  TABLE 2: hiring_forms  (Tab 2 – Employee Hiring Form)
-- ──────────────────────────────────────────────────────────
create table if not exists hiring_forms (
  id                     uuid primary key default gen_random_uuid(),
  submitted_at           timestamptz default now(),

  -- Section 1: Basic Info
  employee_full_name     text,
  employee_id            text,
  gender                 text,
  date_of_birth          date,
  nationality            text,
  personal_email         text,
  work_email             text,
  mobile                 text,
  alternate_mobile       text,
  residential_address    text,
  emergency_contact      text,
  emergency_phone        text,
  emergency_relationship text,

  -- Section 2: Employment
  company                text,
  date_of_joining        date,
  designation            text,
  department             text,
  function_practice      text,
  reporting_manager      text,
  secondary_manager      text,
  work_location          text,
  base_country           text,
  city                   text,
  office_site            text,
  employment_type        text,
  notice_period          text,

  -- Section 3: Contract
  contract_type          text,
  client_name            text,
  project_name           text,
  billing_band_grade     text,
  contract_start         date,
  contract_end           date,
  nda_obligations        text,
  nda_details            text,

  -- Section 4: Compensation
  currency               text,
  current_gross_salary   numeric,
  current_net_salary     numeric,
  proposed_gross_salary  numeric,
  proposed_net_salary    numeric,
  basic_salary           numeric,
  housing_allowance      numeric,
  transport_allowance    numeric,
  mobile_allowance       numeric,
  special_allowance      numeric,
  shift_allowance        numeric,
  overtime_eligible      text,
  bonus_variable_pay     text,
  bonus_details          text,
  salary_buyout          text,

  -- Section 5: Visa / Immigration
  visa_sponsorship       text,
  visa_type              text,
  visa_number            text,
  visa_expiry            date,
  labour_card            text,
  emirates_id            text,
  sponsoring_entity      text,
  family_visa_required   text,
  family_dep_count       integer,
  family_visa_remarks    text,

  -- Section 6: Medical Insurance
  medical_insurance      text,
  insurance_provider     text,
  insurance_plan         text,
  preexisting_condition  text,
  condition_details      text,
  family_medical         text,
  medical_dependents     text,
  children_count_med     integer,

  -- Section 7: Air Ticket
  self_ticket            text,
  self_ticket_freq       text,
  self_route             text,
  family_ticket          text,
  family_ticket_deps     text,
  family_route           text,
  family_ticket_freq     text,

  -- Section 8: Family Dependents (array of objects)
  dependents             jsonb default '[]'::jsonb,

  -- Section 9: Leave
  annual_leave_days      numeric,
  sick_leave_days        numeric,
  compoff_days           numeric,
  other_leave            text,
  leave_encashment       text,
  leave_transfer         text,
  future_leave           text,
  future_leave_details   text,
  special_leave          text,

  -- Section 10: Payroll / Finance
  bank_name              text,
  iban                   text,
  advances_loans         text,
  salary_transfer_letter text,

  -- Section 11: Documents
  employee_docs          text,
  other_emp_docs         text,
  family_docs            text,
  other_fam_docs         text,

  -- Section 12: Compliance
  bgv_completed          text,
  police_verification    text,
  coi_declaration        text,
  nda_signed             text,
  data_privacy_consent   text,
  client_approval        text,
  compliance_remarks     text,

  -- Section 13: Declaration
  declarant_name         text,
  declaration_date       date,
  declaration_agreed     text
);

-- ──────────────────────────────────────────────────────────
--  ROW LEVEL SECURITY (RLS)
--  Employees can INSERT only.
--  Nobody can SELECT via the anon key (admin uses service role).
-- ──────────────────────────────────────────────────────────
alter table ehs_profiles  enable row level security;
alter table hiring_forms   enable row level security;

-- Allow anonymous inserts (employee form)
create policy "allow_anon_insert_ehs"
  on ehs_profiles for insert
  to anon
  with check (true);

create policy "allow_anon_insert_hiring"
  on hiring_forms for insert
  to anon
  with check (true);

-- Block anon reads (admin uses service role which bypasses RLS)
create policy "block_anon_select_ehs"
  on ehs_profiles for select
  to anon
  using (false);

create policy "block_anon_select_hiring"
  on hiring_forms for select
  to anon
  using (false);

-- ──────────────────────────────────────────────────────────
--  INDEXES for faster admin queries
-- ──────────────────────────────────────────────────────────
create index if not exists idx_ehs_submitted    on ehs_profiles  (submitted_at desc);
create index if not exists idx_hiring_submitted on hiring_forms   (submitted_at desc);
create index if not exists idx_ehs_email        on ehs_profiles  (personal_email);
create index if not exists idx_hiring_email     on hiring_forms   (personal_email);
