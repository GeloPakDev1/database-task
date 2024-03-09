-- Add the foreign key constraint
ALTER TABLE subjects
ADD COLUMN tutor_id UUID,
ADD CONSTRAINT fk_tutor
    FOREIGN KEY (tutor_id)
    REFERENCES tutors(id);

-- Remove the tutor column
ALTER TABLE subjects DROP COLUMN tutor;