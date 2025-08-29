/*
# إنشاء قاعدة بيانات المنصة التعليمية
إنشاء جداول المستخدمين، التخصصات، الجلسات، الحجوزات، والمعاملات المالية

## Query Description: 
هذا المخطط سيُنشئ البنية الأساسية للمنصة التعليمية مع جداول منفصلة للمعلمين والطلاب والمدراء، 
بالإضافة إلى نظام إدارة الجلسات والمدفوعات. سيتم تطبيق Row Level Security لحماية البيانات.

## Metadata:
- Schema-Category: "Structural"
- Impact-Level: "Medium"
- Requires-Backup: false
- Reversible: true

## Structure Details:
- user_profiles: معلومات المستخدمين الأساسية
- teacher_profiles: ملفات المعلمين مع التخصصات والخبرة
- student_profiles: ملفات الطلاب
- subjects: التخصصات المتاحة
- sessions: الجلسات التعليمية
- bookings: حجوزات الجلسات
- payments: المعاملات المالية
- reviews: تقييمات الطلاب

## Security Implications:
- RLS Status: Enabled
- Policy Changes: Yes
- Auth Requirements: Supabase Auth integration required

## Performance Impact:
- Indexes: Added for foreign keys and search columns
- Triggers: Added for automatic profile creation
- Estimated Impact: Low to medium - optimized for read/write operations
*/

-- تمكين Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- إنشاء جدول أنواع المستخدمين (enum)
CREATE TYPE user_role AS ENUM ('student', 'teacher', 'admin');
CREATE TYPE session_status AS ENUM ('scheduled', 'completed', 'cancelled', 'in_progress');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'cancelled', 'completed');
CREATE TYPE payment_status AS ENUM ('pending', 'completed', 'failed', 'refunded');

-- جدول ملفات المستخدمين الأساسية
CREATE TABLE user_profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    avatar_url TEXT,
    role user_role NOT NULL DEFAULT 'student',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- جدول التخصصات
CREATE TABLE subjects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    icon_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- جدول ملفات المعلمين
CREATE TABLE teacher_profiles (
    id UUID REFERENCES user_profiles(id) ON DELETE CASCADE PRIMARY KEY,
    bio TEXT,
    years_of_experience INTEGER DEFAULT 0,
    hourly_rate DECIMAL(10,2) NOT NULL,
    qualification TEXT,
    is_verified BOOLEAN DEFAULT false,
    total_sessions INTEGER DEFAULT 0,
    average_rating DECIMAL(3,2) DEFAULT 0.0,
    total_earnings DECIMAL(12,2) DEFAULT 0.0,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- جدول تخصصات المعلمين (many-to-many)
CREATE TABLE teacher_subjects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    teacher_id UUID REFERENCES teacher_profiles(id) ON DELETE CASCADE,
    subject_id UUID REFERENCES subjects(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(teacher_id, subject_id)
);

-- جدول ملفات الطلاب
CREATE TABLE student_profiles (
    id UUID REFERENCES user_profiles(id) ON DELETE CASCADE PRIMARY KEY,
    grade_level TEXT,
    total_sessions INTEGER DEFAULT 0,
    total_spent DECIMAL(12,2) DEFAULT 0.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- جدول الجلسات
CREATE TABLE sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    teacher_id UUID REFERENCES teacher_profiles(id) ON DELETE CASCADE,
    student_id UUID REFERENCES student_profiles(id) ON DELETE CASCADE,
    subject_id UUID REFERENCES subjects(id),
    title TEXT NOT NULL,
    description TEXT,
    scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
    duration_minutes INTEGER NOT NULL DEFAULT 60,
    hourly_rate DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    platform_fee DECIMAL(10,2) NOT NULL, -- 10% fee
    teacher_amount DECIMAL(10,2) NOT NULL, -- 90% for teacher
    status session_status DEFAULT 'scheduled',
    meeting_url TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- جدول الحجوزات
CREATE TABLE bookings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    student_id UUID REFERENCES student_profiles(id) ON DELETE CASCADE,
    status booking_status DEFAULT 'pending',
    booking_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- جدول المدفوعات
CREATE TABLE payments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    student_id UUID REFERENCES student_profiles(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    platform_fee DECIMAL(10,2) NOT NULL,
    teacher_amount DECIMAL(10,2) NOT NULL,
    payment_method TEXT,
    stripe_payment_id TEXT,
    status payment_status DEFAULT 'pending',
    paid_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- جدول التقييمات
CREATE TABLE reviews (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    student_id UUID REFERENCES student_profiles(id) ON DELETE CASCADE,
    teacher_id UUID REFERENCES teacher_profiles(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    is_anonymous BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- جدول إعدادات المنصة
CREATE TABLE platform_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value TEXT NOT NULL,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إدراج الإعدادات الافتراضية
INSERT INTO platform_settings (key, value, description) VALUES
    ('platform_fee_percentage', '10', 'Platform commission percentage'),
    ('min_session_duration', '30', 'Minimum session duration in minutes'),
    ('max_session_duration', '180', 'Maximum session duration in minutes'),
    ('currency', 'USD', 'Platform currency');

-- إنشاء الفهارس لتحسين الأداء
CREATE INDEX idx_user_profiles_role ON user_profiles(role);
CREATE INDEX idx_user_profiles_email ON user_profiles(email);
CREATE INDEX idx_teacher_profiles_hourly_rate ON teacher_profiles(hourly_rate);
CREATE INDEX idx_teacher_profiles_rating ON teacher_profiles(average_rating);
CREATE INDEX idx_sessions_teacher_id ON sessions(teacher_id);
CREATE INDEX idx_sessions_student_id ON sessions(student_id);
CREATE INDEX idx_sessions_scheduled_at ON sessions(scheduled_at);
CREATE INDEX idx_sessions_status ON sessions(status);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_reviews_teacher_id ON reviews(teacher_id);

-- تمكين Row Level Security
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE teacher_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE teacher_subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- سياسات الأمان للملفات الشخصية
CREATE POLICY "Users can view own profile" ON user_profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON user_profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Public profiles viewable by all" ON user_profiles FOR SELECT USING (true);

-- سياسات المعلمين
CREATE POLICY "Teachers can manage own profile" ON teacher_profiles FOR ALL USING (auth.uid() = id);
CREATE POLICY "Anyone can view teacher profiles" ON teacher_profiles FOR SELECT USING (true);

-- سياسات الطلاب
CREATE POLICY "Students can manage own profile" ON student_profiles FOR ALL USING (auth.uid() = id);

-- سياسات التخصصات
CREATE POLICY "Anyone can view subjects" ON subjects FOR SELECT USING (true);
CREATE POLICY "Only admins can manage subjects" ON subjects FOR ALL USING (
    EXISTS (
        SELECT 1 FROM user_profiles 
        WHERE id = auth.uid() AND role = 'admin'
    )
);

-- سياسات الجلسات
CREATE POLICY "Users can view own sessions" ON sessions FOR SELECT USING (
    teacher_id = auth.uid() OR student_id = auth.uid()
);
CREATE POLICY "Teachers can manage own sessions" ON sessions FOR ALL USING (teacher_id = auth.uid());

-- سياسات الحجوزات
CREATE POLICY "Users can view own bookings" ON bookings FOR SELECT USING (
    student_id = auth.uid() OR 
    EXISTS (SELECT 1 FROM sessions WHERE id = session_id AND teacher_id = auth.uid())
);

-- سياسات المدفوعات
CREATE POLICY "Users can view own payments" ON payments FOR SELECT USING (
    student_id = auth.uid() OR 
    EXISTS (SELECT 1 FROM sessions WHERE id = session_id AND teacher_id = auth.uid())
);

-- سياسات التقييمات
CREATE POLICY "Anyone can view reviews" ON reviews FOR SELECT USING (true);
CREATE POLICY "Students can create reviews" ON reviews FOR INSERT USING (student_id = auth.uid());

-- إنشاء trigger لتحديث تاريخ التحديث
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_teacher_profiles_updated_at BEFORE UPDATE ON teacher_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_student_profiles_updated_at BEFORE UPDATE ON student_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sessions_updated_at BEFORE UPDATE ON sessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- إنشاء trigger لإنشاء ملف تعريفي تلقائياً عند التسجيل
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.user_profiles (id, full_name, email, role)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
        NEW.email,
        COALESCE((NEW.raw_user_meta_data->>'role')::user_role, 'student'::user_role)
    );
    
    -- إنشاء ملف طالب أو معلم حسب النوع
    IF COALESCE((NEW.raw_user_meta_data->>'role')::user_role, 'student'::user_role) = 'student' THEN
        INSERT INTO public.student_profiles (id) VALUES (NEW.id);
    ELSIF COALESCE((NEW.raw_user_meta_data->>'role')::user_role, 'student'::user_role) = 'teacher' THEN
        INSERT INTO public.teacher_profiles (id, hourly_rate) VALUES (NEW.id, 25.00);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- إنشاء trigger لتحديث إحصائيات المعلم عند إضافة تقييم
CREATE OR REPLACE FUNCTION update_teacher_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE teacher_profiles 
    SET average_rating = (
        SELECT AVG(rating)::DECIMAL(3,2) 
        FROM reviews 
        WHERE teacher_id = NEW.teacher_id
    )
    WHERE id = NEW.teacher_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_teacher_rating_trigger
    AFTER INSERT ON reviews
    FOR EACH ROW EXECUTE FUNCTION update_teacher_rating();

-- إدراج بعض التخصصات الافتراضية
INSERT INTO subjects (name, description) VALUES
    ('الرياضيات', 'دروس في الجبر، الهندسة، والحساب'),
    ('الفيزياء', 'دروس في الفيزياء النظرية والتطبيقية'),
    ('الكيمياء', 'دروس في الكيمياء العامة والعضوية'),
    ('اللغة العربية', 'دروس في القواعد والأدب والبلاغة'),
    ('اللغة الإنجليزية', 'دروس في القواعد والمحادثة والكتابة'),
    ('علوم الحاسوب', 'دروس في البرمجة وعلوم الحاسوب'),
    ('التاريخ', 'دروس في التاريخ القديم والحديث'),
    ('الجغرافيا', 'دروس في الجغرافيا الطبيعية والبشرية');
