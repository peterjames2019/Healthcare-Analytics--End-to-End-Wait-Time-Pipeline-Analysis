

with dataset as (
    select * from {{ ref('healthcare_appointments') }}
)

select
    appointment_id,
    patient_id,
    doctor_id,
    specialty,
    scheduled_time as scheduled_at,
    status as appointment_status
from dataset