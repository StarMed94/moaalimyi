import 'react-native-url-polyfill/auto';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL!;
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
  },
});

// Types for our database
export type UserRole = 'student' | 'teacher' | 'admin';
export type SessionStatus = 'scheduled' | 'completed' | 'cancelled' | 'in_progress';
export type BookingStatus = 'pending' | 'confirmed' | 'cancelled' | 'completed';
export type PaymentStatus = 'pending' | 'completed' | 'failed' | 'refunded';

export interface UserProfile {
  id: string;
  full_name: string;
  email: string;
  phone?: string;
  avatar_url?: string;
  role: UserRole;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface TeacherProfile {
  id: string;
  bio?: string;
  years_of_experience: number;
  hourly_rate: number;
  qualification?: string;
  is_verified: boolean;
  total_sessions: number;
  average_rating: number;
  total_earnings: number;
  is_available: boolean;
  user_profiles?: UserProfile;
  teacher_subjects?: { subjects: Subject }[];
}

export interface StudentProfile {
  id: string;
  grade_level?: string;
  total_sessions: number;
  total_spent: number;
  user_profiles?: UserProfile;
}

export interface Subject {
  id: string;
  name: string;
  description?: string;
  icon_url?: string;
  is_active: boolean;
}

export interface Session {
  id: string;
  teacher_id: string;
  student_id: string;
  subject_id: string;
  title: string;
  description?: string;
  scheduled_at: string;
  duration_minutes: number;
  hourly_rate: number;
  total_amount: number;
  platform_fee: number;
  teacher_amount: number;
  status: SessionStatus;
  meeting_url?: string;
  notes?: string;
  teacher_profiles?: TeacherProfile;
  student_profiles?: StudentProfile;
  subjects?: Subject;
}

export interface Review {
  id: string;
  session_id: string;
  student_id: string;
  teacher_id: string;
  rating: number;
  comment?: string;
  is_anonymous: boolean;
  created_at: string;
  student_profiles?: StudentProfile;
}
