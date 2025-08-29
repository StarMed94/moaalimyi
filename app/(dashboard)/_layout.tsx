import React from 'react';
import { Redirect } from 'expo-router';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { useAuth } from '../../contexts/AuthContext';
import { Home, Search, Calendar, User, BarChart } from 'lucide-react-native';

import StudentDashboard from './student';
import TeacherDashboard from './teacher';
import AdminDashboard from './admin';
import ProfileScreen from './profile';
import SearchScreen from './search';

const Tab = createBottomTabNavigator();

export default function DashboardLayout() {
  const { user, userProfile, loading } = useAuth();

  if (loading) {
    return null; // Or a loading spinner
  }

  if (!user || !userProfile) {
    return <Redirect href="/(auth)/login" />;
  }

  const getTabScreens = () => {
    if (userProfile.role === 'admin') {
      return (
        <>
          <Tab.Screen 
            name="admin" 
            component={AdminDashboard}
            options={{
              title: 'الإحصائيات',
              tabBarIcon: ({ color, size }) => <BarChart size={size} color={color} />,
            }}
          />
          <Tab.Screen 
            name="search" 
            component={SearchScreen}
            options={{
              title: 'البحث',
              tabBarIcon: ({ color, size }) => <Search size={size} color={color} />,
            }}
          />
          <Tab.Screen 
            name="profile" 
            component={ProfileScreen}
            options={{
              title: 'الملف الشخصي',
              tabBarIcon: ({ color, size }) => <User size={size} color={color} />,
            }}
          />
        </>
      );
    } else if (userProfile.role === 'teacher') {
      return (
        <>
          <Tab.Screen 
            name="teacher" 
            component={TeacherDashboard}
            options={{
              title: 'لوحة التحكم',
              tabBarIcon: ({ color, size }) => <Home size={size} color={color} />,
            }}
          />
          <Tab.Screen 
            name="search" 
            component={SearchScreen}
            options={{
              title: 'الطلاب',
              tabBarIcon: ({ color, size }) => <Search size={size} color={color} />,
            }}
          />
          <Tab.Screen 
            name="profile" 
            component={ProfileScreen}
            options={{
              title: 'الملف الشخصي',
              tabBarIcon: ({ color, size }) => <User size={size} color={color} />,
            }}
          />
        </>
      );
    } else {
      return (
        <>
          <Tab.Screen 
            name="student" 
            component={StudentDashboard}
            options={{
              title: 'الرئيسية',
              tabBarIcon: ({ color, size }) => <Home size={size} color={color} />,
            }}
          />
          <Tab.Screen 
            name="search" 
            component={SearchScreen}
            options={{
              title: 'البحث',
              tabBarIcon: ({ color, size }) => <Search size={size} color={color} />,
            }}
          />
          <Tab.Screen 
            name="profile" 
            component={ProfileScreen}
            options={{
              title: 'الملف الشخصي',
              tabBarIcon: ({ color, size }) => <User size={size} color={color} />,
            }}
          />
        </>
      );
    }
  };

  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: '#667eea',
        tabBarInactiveTintColor: '#999',
        tabBarStyle: {
          backgroundColor: '#fff',
          borderTopWidth: 1,
          borderTopColor: '#eee',
          paddingBottom: 5,
          paddingTop: 5,
          height: 60,
        },
      }}
    >
      {getTabScreens()}
    </Tab.Navigator>
  );
}
