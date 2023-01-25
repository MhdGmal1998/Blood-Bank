import * as React from "react";
import {
  AppBar,
  Box,
  Toolbar,
  Link,
  CardMedia,
  Typography,
} from "@mui/material";
import { useState } from "react";
import { EmotionList } from "./motion-navbar";
import { SECONDARY_COLOR } from "../../constant/color";
import { ProfileAvatar } from "./profile-avatar/index.jsx";
import { SearchBar } from "./search-bar";
import { useAuthContext } from "../../context/auth-context";
const navItems = [
  {
    id: 1,
    name: "الرئيسية",
    href: "/",
  },
  {
    id: 2,
    name: "من نحن",
    href: "/aboutus",
  },
  {
    id: 3,
    name: "تبرع",
    href: "#about",
  },
  {
    id: 4,
    name: "البحث عن متبرع",
    href: "/search",
  },
  {
    id: 5,
    name: "الخريطة",
    href: "/map",
  },
];

const fontColor = "#343a40";
const RedColorValue = "#e63946";
const NavBar = (props) => {
  const [mobileOpen, setMobileOpen] = useState(false);
  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };
  const navItemsList = navItems.map((item) => (
    <Link
      href={item.href}
      key={item.name}
      sx={{
        color: fontColor,
        textDecoration: "none",
        transition: "0.5s",
        p: 2,
        "&:hover": {
          color: "white",
          backgroundColor: SECONDARY_COLOR,
          borderRadius: 1,
        },
      }}
    >
      <Typography sx={{ display: "inline" }}> {item.name}</Typography>
    </Link>
  ));
  return (
    <>
      <AppBar
        sx={{
          backgroundColor: "white",
          position: "fixed",
        }}
      >
        <Toolbar
          sx={{
            display: "flex",
            justifyContent: "space-between",
          }}
        >
          <Box sx={{ display: { xs: "block", md: "none" }, mb: 9 }}>
            <EmotionList />
          </Box>
          <Box
            sx={{
              display: { xs: "none", md: "flex" },
              alignItems: "center",
            }}
          >
            <ProfileAvatar />
            <Box>{navItemsList}</Box>
          </Box>
          <Box
            sx={{
              width: "40px",
              height: "40px",
              cursor: "pointer",
            }}
          >
            <CardMedia component="img" image="/logo.png" />
          </Box>
        </Toolbar>
      </AppBar>
    </>
  );
};
export default NavBar;
