

with appointments as (
    select * from {{ ref('stg_appointments') }}
),

patients as (
    select * from {{ ref('stg_patients') }}
),

events as (
    -- This pulls the logic we built for event durations
    select 
        appointment_id,
        min(case when event_name = 'Check-in' then occurred_at end) as check_in_at,
        min(case when event_name = 'Vitals End' then occurred_at end) as vitals_completed_at
    from {{ ref('stg_clinical_events') }}
    group by 1
),

final_joined as (

    select
        a.appointment_id,
        p.patient_id,
        a.appointment_status,
        a.specialty,
        p.insurance_provider,
        a.scheduled_at,
        e.check_in_at,
        e.vitals_completed_at,
        
        -- Calculate wait time from check-in to vitals completion
    ROUND(
            (extract(epoch from (e.vitals_completed_at - e.check_in_at)) / 60.0)::numeric, 
            1
        ) as wait_time_minutes

    from appointments a
    left join patients p on a.patient_id = p.patient_id
    left join events e on a.appointment_id = e.appointment_id  

)
select * from final_joined
where wait_time_minutes is NOT NULL
