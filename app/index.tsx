import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { Link } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { BookOpen, Users, Award, TrendingUp } from 'lucide-react-native';

export default function LandingPage() {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.logo}>📚 منصة التعلم</Text>
          <View style={styles.headerButtons}>
            <Link href="/auth/login" asChild>
              <TouchableOpacity style={styles.loginButton}>
                <Text style={styles.loginButtonText}>تسجيل الدخول</Text>
              </TouchableOpacity>
            </Link>
          </View>
        </View>

        {/* Hero Section */}
        <LinearGradient
          colors={['#667eea', '#764ba2']}
          style={styles.heroSection}
        >
          <View style={styles.heroContent}>
            <Text style={styles.heroTitle}>منصة تعليمية تربط بين المعلمين والطلاب</Text>
            <Text style={styles.heroSubtitle}>
              احجز دروساً خاصة مع أفضل المعلمين في جميع التخصصات
            </Text>
            <Link href="/auth/register" asChild>
              <TouchableOpacity style={styles.ctaButton}>
                <Text style={styles.ctaButtonText}>ابدأ التعلم الآن</Text>
              </TouchableOpacity>
            </Link>
          </View>
        </LinearGradient>

        {/* Features Section */}
        <View style={styles.featuresSection}>
          <Text style={styles.sectionTitle}>مميزات المنصة</Text>
          <View style={styles.featuresGrid}>
            <View style={styles.featureCard}>
              <BookOpen size={40} color="#667eea" />
              <Text style={styles.featureTitle}>دروس تفاعلية</Text>
              <Text style={styles.featureDescription}>
                دروس مباشرة وتفاعلية مع أفضل المعلمين
              </Text>
            </View>
            
            <View style={styles.featureCard}>
              <Users size={40} color="#667eea" />
              <Text style={styles.featureTitle}>معلمون مؤهلون</Text>
              <Text style={styles.featureDescription}>
                معلمون معتمدون وذوو خبرة في تخصصاتهم
              </Text>
            </View>
            
            <View style={styles.featureCard}>
              <Award size={40} color="#667eea" />
              <Text style={styles.featureTitle}>نظام تقييم</Text>
              <Text style={styles.featureDescription}>
                تقييم المعلمين والطلاب لضمان جودة التعليم
              </Text>
            </View>
            
            <View style={styles.featureCard}>
              <TrendingUp size={40} color="#667eea" />
              <Text style={styles.featureTitle}>تتبع التقدم</Text>
              <Text style={styles.featureDescription}>
                متابعة مستمرة لتقدم الطلاب وأداء المعلمين
              </Text>
            </View>
          </View>
        </View>

        {/* Statistics Section */}
        <LinearGradient
          colors={['#f093fb', '#f5576c']}
          style={styles.statsSection}
        >
          <Text style={styles.sectionTitle}>إحصائياتنا</Text>
          <View style={styles.statsGrid}>
            <View style={styles.statCard}>
              <Text style={styles.statNumber}>500+</Text>
              <Text style={styles.statLabel}>معلم</Text>
            </View>
            <View style={styles.statCard}>
              <Text style={styles.statNumber}>2000+</Text>
              <Text style={styles.statLabel}>طالب</Text>
            </View>
            <View style={styles.statCard}>
              <Text style={styles.statNumber}>10000+</Text>
              <Text style={styles.statLabel}>درس</Text>
            </View>
            <View style={styles.statCard}>
              <Text style={styles.statNumber}>4.8</Text>
              <Text style={styles.statLabel}>تقييم</Text>
            </View>
          </View>
        </LinearGradient>

        {/* CTA Section */}
        <View style={styles.ctaSection}>
          <Text style={styles.ctaTitle}>هل أنت معلم؟</Text>
          <Text style={styles.ctaDescription}>
            انضم إلى منصتنا وابدأ في تدريس الطلاب وكسب المال
          </Text>
          <Link href="/auth/register?role=teacher" asChild>
            <TouchableOpacity style={styles.teacherCtaButton}>
              <Text style={styles.teacherCtaButtonText}>انضم كمعلم</Text>
            </TouchableOpacity>
          </Link>
        </View>

        {/* Footer */}
        <View style={styles.footer}>
          <Text style={styles.footerText}>© 2025 منصة التعلم. جميع الحقوق محفوظة.</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 15,
    backgroundColor: '#fff',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  logo: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#667eea',
  },
  headerButtons: {
    flexDirection: 'row',
    gap: 10,
  },
  loginButton: {
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 25,
    borderWidth: 1,
    borderColor: '#667eea',
  },
  loginButtonText: {
    color: '#667eea',
    fontWeight: '600',
  },
  heroSection: {
    paddingHorizontal: 20,
    paddingVertical: 60,
    alignItems: 'center',
  },
  heroContent: {
    alignItems: 'center',
    maxWidth: '100%',
  },
  heroTitle: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#fff',
    textAlign: 'center',
    marginBottom: 15,
    lineHeight: 40,
  },
  heroSubtitle: {
    fontSize: 18,
    color: '#fff',
    textAlign: 'center',
    marginBottom: 30,
    opacity: 0.9,
    lineHeight: 24,
  },
  ctaButton: {
    backgroundColor: '#fff',
    paddingHorizontal: 30,
    paddingVertical: 15,
    borderRadius: 30,
  },
  ctaButtonText: {
    color: '#667eea',
    fontSize: 18,
    fontWeight: 'bold',
  },
  featuresSection: {
    paddingHorizontal: 20,
    paddingVertical: 60,
  },
  sectionTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 40,
    color: '#333',
  },
  featuresGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    gap: 20,
  },
  featureCard: {
    width: '48%',
    backgroundColor: '#fff',
    padding: 20,
    borderRadius: 15,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 5,
    marginBottom: 20,
  },
  featureTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
    marginVertical: 10,
  },
  featureDescription: {
    fontSize: 14,
    color: '#666',
    textAlign: 'center',
    lineHeight: 20,
  },
  statsSection: {
    paddingHorizontal: 20,
    paddingVertical: 60,
  },
  statsGrid: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    flexWrap: 'wrap',
  },
  statCard: {
    width: '48%',
    alignItems: 'center',
    marginBottom: 20,
  },
  statNumber: {
    fontSize: 36,
    fontWeight: 'bold',
    color: '#fff',
  },
  statLabel: {
    fontSize: 16,
    color: '#fff',
    opacity: 0.9,
  },
  ctaSection: {
    paddingHorizontal: 20,
    paddingVertical: 60,
    alignItems: 'center',
    backgroundColor: '#f8f9fa',
  },
  ctaTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 15,
  },
  ctaDescription: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 30,
    lineHeight: 22,
  },
  teacherCtaButton: {
    backgroundColor: '#28a745',
    paddingHorizontal: 30,
    paddingVertical: 15,
    borderRadius: 30,
  },
  teacherCtaButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  footer: {
    paddingHorizontal: 20,
    paddingVertical: 30,
    backgroundColor: '#333',
    alignItems: 'center',
  },
  footerText: {
    color: '#fff',
    fontSize: 14,
  },
});
